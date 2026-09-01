import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/service/dio_provdier.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/feature/setting/repository/setting_repository.dart';
import 'package:tele_book/feature/sync/model/request/file_request.dart';
import 'package:tele_book/feature/sync/model/response/file_response.dart';

final fileSyncServiceProvider = Provider<FileSyncService>((ref) {
  return FileSyncService(
    ref.watch(settingRepositoryProvider),
    ref.watch(serverDioProvider),
  );
});

/// 书籍内的一个文件（hash 引用，与服务器 payload.files 同构）。
class BookFileItem {
  final String relPath; // 书籍内相对路径，如 cover.jpg / original/0000000.jpg
  final String absPath; // 本地绝对路径
  final String hash; // SHA-256
  final int size;

  const BookFileItem({
    required this.relPath,
    required this.absPath,
    required this.hash,
    required this.size,
  });

  Map<String, dynamic> toJson() => {
        'rel_path': relPath,
        'hash': hash,
        'size': size,
      };
}

/// 书籍图片文件同步：SHA-256 计算 / 批量比对 / 分片上传 / hash 下载。
///
/// 服务器为内容寻址（MinIO 对象键 = sha256），跨设备去重：
/// 上传前先 /files/check 比对，缺失才传；下载按 hash 取预签名地址。
class FileSyncService {
  /// 分片大小（S3 规则：非末尾分片 ≥ 5MB，这里用 8MB）。
  static const int chunkSize = 8 * 1024 * 1024;

  final SettingRepository _settings;
  final Dio _dio;

  /// 文件 hash 缓存：key = 路径:大小，value = (hash, mtime)。
  /// 图片文件在导入/编辑后不再变化，快照捕获（整库重算 hash）靠它秒出。
  final Map<String, _CachedHash> _hashCache = {};

  FileSyncService(this._settings, this._dio);

  Future<Options> _authOptions() async {
    final token = await _settings.getString(SyncSettings.token);
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  /// 流式计算文件 SHA-256（内存安全，不整文件载入）。
  static Future<String> hashFile(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw StateError('文件不存在: $path');
    }
    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString();
  }

  /// 批量比对：返回远端缺失的 hash 集合。
  Future<Set<String>> checkMissing(List<String> hashes) async {
    if (hashes.isEmpty) return {};
    final url = await _settings.getString(SyncSettings.serverUrl);
    final res = await _dio.post<Map<String, dynamic>>(
      '$url/api/v1/files/check',
      data: FileCheckRequest(
        files: hashes.map((h) => FileHashItem(hash: h)).toList(),
      ).toJson(),
      options: await _authOptions(),
    );
    final missing = FileCheckResponse.fromJson(res.data ?? {}).missing;
    return missing.map((m) => m.hash).toSet();
  }

  /// 上传单个文件（8MB 分片）。文件已存在（另一设备已传）则跳过。
  /// [onProgress] 0.0–1.0（全书聚合用）。
  Future<void> uploadFile({
    required String path,
    required String hash,
    required int size,
    void Function(double progress)? onProgress,
  }) async {
    if (size <= 0) return;
    final url = await _settings.getString(SyncSettings.serverUrl);

    // 1. init（文件已存在 → complete=true 幂等跳过）
    final init = await _dio.post<Map<String, dynamic>>(
      '$url/api/v1/files/upload/init',
      data: FileInitUploadRequest(hash: hash, size: size).toJson(),
      options: await _authOptions(),
    );
    final initResp = FileInitUploadResponse.fromJson(init.data ?? {});
    if (initResp.complete) {
      onProgress?.call(1);
      return;
    }
    final uploadId = initResp.uploadId;
    if (uploadId == null || uploadId.isEmpty) {
      throw StateError('上传初始化失败: 未返回 upload_id');
    }

    // 2. 分片上传
    final totalParts = (size / chunkSize).ceil();
    final parts = <FilePartMeta>[];
    final raf = await File(path).open();
    var sent = 0;
    try {
      for (var i = 0; i < totalParts; i++) {
        final offset = i * chunkSize;
        final length = i == totalParts - 1 ? size - offset : chunkSize;
        await raf.setPosition(offset);
        final bytes = await raf.read(length);
        final form = FormData.fromMap({
          'hash': hash,
          'upload_id': uploadId,
          'part_number': i + 1,
          'chunk': MultipartFile.fromBytes(bytes, filename: 'part${i + 1}'),
        });
        final res = await _dio.post<Map<String, dynamic>>(
          '$url/api/v1/files/upload',
          data: form,
          options: await _authOptions(),
          onSendProgress: (sentNow, _) {
            final partSent = sent + (sentNow == 0 ? 0 : bytes.length);
            onProgress?.call((partSent / size).clamp(0.0, 1.0));
          },
        );
        parts.add(
          FilePartMeta(
            partNumber: i + 1,
            etag: res.data?['etag'] as String? ?? '',
          ),
        );
        sent += bytes.length;
      }
    } finally {
      await raf.close();
    }

    // 3. complete
    await _dio.post<Map<String, dynamic>>(
      '$url/api/v1/files/upload/complete',
      data: FileCompleteUploadRequest(
        hash: hash,
        uploadId: uploadId,
        size: size,
        totalParts: totalParts,
        parts: parts,
      ).toJson(),
      options: await _authOptions(),
    );
    onProgress?.call(1);
  }

  /// 按 hash 下载到目标路径（跟随 302 预签名跳转），父目录自动创建。
  Future<void> downloadFile({
    required String hash,
    required String destPath,
    void Function(double progress)? onProgress,
  }) async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final file = File(destPath);
    await file.parent.create(recursive: true);
    await _dio.download(
      '$url/api/v1/files/download?hash=$hash',
      destPath,
      options: await _authOptions(),
      onReceiveProgress: (received, total) {
        onProgress?.call(total > 0 ? (received / total).clamp(0.0, 1.0) : 0);
      },
    );
    onProgress?.call(1);
  }

  /// 构建一本书的文件清单（封面 + 原图），并计算 hash。
  Future<List<BookFileItem>> buildBookFiles(BookTableData book) {
    return buildBookFilesFor(
      localSubPaths: book.localSubPaths,
      coverSubPath: book.coverSubPath,
    );
  }

  /// 按路径构建文件清单（导入场景：本地书行尚未创建）。
  Future<List<BookFileItem>> buildBookFilesFor({
    required List<String> localSubPaths,
    String? coverSubPath,
  }) async {
    final items = <BookFileItem>[];
    final seen = <String>{};

    // 封面：coverSubPath 或第一张原图
    final coverSub = coverSubPath ??
        (localSubPaths.isNotEmpty ? localSubPaths.first : null);
    if (coverSub != null) {
      final abs = GlobalConfig.resolveBookPath(coverSub);
      if (await File(abs).exists()) {
        items.add(await _makeItem('cover.jpg', abs));
        seen.add(abs);
      }
    }

    // 原图
    for (final sub in localSubPaths) {
      final abs = GlobalConfig.resolveBookPath(sub);
      if (seen.contains(abs)) continue;
      if (!await File(abs).exists()) continue;
      items.add(await _makeItem(_relPathOf(sub), abs));
    }
    return items;
  }

  /// 上传书籍缺失的图片文件（按 hash 去重），返回完整文件清单。
  Future<List<BookFileItem>> ensureUploaded(
    List<BookFileItem> files, {
    void Function(double progress)? onProgress,
  }) async {
    if (files.isEmpty) return files;
    final missing = await checkMissing(files.map((f) => f.hash).toList());
    if (missing.isEmpty) {
      onProgress?.call(1);
      return files;
    }
    var done = 0;
    for (final f in files) {
      if (!missing.contains(f.hash)) {
        done++;
        continue;
      }
      await uploadFile(path: f.absPath, hash: f.hash, size: f.size);
      done++;
      onProgress?.call(done / files.length);
    }
    return files;
  }

  Future<BookFileItem> _makeItem(String relPath, String absPath) async {
    final file = File(absPath);
    final stat = await file.stat();
    final mtime = stat.modified.millisecondsSinceEpoch;
    final key = '$absPath:${stat.size}';
    final cached = _hashCache[key];
    final String hash;
    if (cached != null && cached.mtime == mtime) {
      hash = cached.hash; // 文件未变，直接用缓存的 hash
    } else {
      hash = await hashFile(absPath);
      _hashCache[key] = _CachedHash(hash, mtime);
    }
    return BookFileItem(
      relPath: relPath,
      absPath: absPath,
      hash: hash,
      size: stat.size,
    );
  }

  /// subPath（booksDir 下，如 "uuid/original/0000000.jpg"）→ 书籍内相对路径。
  static String _relPathOf(String subPath) {
    final segments = subPath
        .replaceAll('\\', '/')
        .split('/')
        .where((e) => e.isNotEmpty)
        .toList();
    if (segments.length <= 1) return subPath;
    return segments.sublist(1).join('/');
  }
}

/// 缓存的文件 hash（带 mtime 校验，文件变化自动失效）。
class _CachedHash {
  final String hash;
  final int mtime;

  const _CachedHash(this.hash, this.mtime);
}
