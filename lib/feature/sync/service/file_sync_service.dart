import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/service/dio_provdier.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/core/util/app_log.dart';
import 'package:tele_book/feature/setting/repository/setting_repository.dart';
import 'package:tele_book/feature/sync/model/request/book_upload_request.dart';
import 'package:tele_book/feature/sync/model/request/file_request.dart';
import 'package:tele_book/feature/sync/model/request/sync_request.dart';
import 'package:tele_book/feature/sync/model/response/file_response.dart';
import 'package:tele_book/feature/sync/service/sync_op_service.dart';

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

  /// 放弃服务器端上传任务（§8.2 清理：本地覆盖/删除该书后调用，幂等）。
  /// 失败静默忽略——服务端任务由下次同 uuid init 幂等重建覆盖。
  Future<void> abandonUpload(String uuid) async {
    try {
      final url = await _settings.getString(SyncSettings.serverUrl);
      await _dio.post<Map<String, dynamic>>(
        '$url/api/v1/upload/abandon/$uuid',
        options: await _authOptions(),
      );
    } catch (e) {
      AppLog.w('放弃上传任务失败(可忽略) $uuid: $e', tag: 'UPLOAD');
    }
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

  /// 单个文件上传失败自动重试次数（网络/超时抖动，指数退避 1s/2s/4s，§8.7.5）。
  static const _uploadRetries = 3;

  /// 上传单个文件（8MB 分片）。文件已存在（另一设备已传）则跳过。
  /// 失败自动重试 [_uploadRetries] 次（指数退避 1s/2s/4s），每次重试重新 init
  /// （新 upload_id）；全部失败抛出最后一次错误（调用方标记书失败/保留断点）。
  /// [onProgress] 0.0–1.0（全书聚合用）。
  ///
  /// ⚠️ 分片大小与数量始终以**本地文件真实大小**为准，不信任调用方传入的
  /// [size]（payload 快照可能过时/与实际文件不一致，否则 MinIO 对象会
  /// 记录声明大小但实际数据不足，下载时校验失败）。
  Future<void> uploadFile({
    required String path,
    required String hash,
    required int size,
    void Function(double progress)? onProgress,
  }) async {
    final url = await _settings.getString(SyncSettings.serverUrl);

    // 用真实文件大小覆盖调用方传入的 size
    final realSize = await File(path).length();
    if (realSize <= 0) return;
    size = realSize;

    Object? lastError;
    for (var attempt = 1; attempt <= _uploadRetries; attempt++) {
      try {
        await _uploadFileOnce(
          url: url,
          path: path,
          hash: hash,
          size: size,
          onProgress: onProgress,
        );
        return;
      } catch (e) {
        lastError = e;
        if (attempt < _uploadRetries) {
          AppLog.w(
            '上传失败($hash) 第 $attempt 次，重试中: $e',
            tag: 'UPLOAD',
          );
          await Future<void>.delayed(Duration(seconds: 1 << (attempt - 1)));
        }
      }
    }
    throw lastError ?? StateError('上传失败: $hash');
  }

  /// 单次上传尝试：init（文件已存在 → complete=true 幂等跳过）→ 分片 → complete。
  Future<void> _uploadFileOnce({
    required String? url,
    required String path,
    required String hash,
    required int size,
    void Function(double progress)? onProgress,
  }) async {
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
    var completedParts = 0;
    try {
      for (var i = 0; i < totalParts; i++) {
        final offset = i * chunkSize;
        final length = i == totalParts - 1 ? size - offset : chunkSize;
        await raf.setPosition(offset);
        final bytes = await raf.read(length);
        // 读完的长度可能 < length（文件并发截断/损坏）→ 视为失败，避免上传不完整对象
        if (bytes.length != length) {
          throw StateError('读取文件分片不完整: $path part=${i + 1} 期望$length 实际${bytes.length}');
        }
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
        // 服务器可能返回"文件已存在"（并发场景）→ 视为该文件已完成
        if (res.data?['complete'] == true) {
          parts.clear();
          completedParts = 0;
          sent = size;
          break;
        }
        final etag = res.data?['etag'] as String? ?? '';
        if (etag.isEmpty) {
          throw StateError('上传分片未返回 etag: $hash part=${i + 1}');
        }
        parts.add(FilePartMeta(partNumber: i + 1, etag: etag));
        sent += bytes.length;
        completedParts++;
      }
    } finally {
      await raf.close();
    }

    // 3. complete（校验分片齐全：跳过"文件已存在"的提前完成场景）
    if (completedParts == totalParts && parts.length == totalParts) {
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
    }
    onProgress?.call(1);
  }

  /// 下载超时：图片走 API 代理（服务器转 MinIO），慢网络下 15s 远不够。
  static const _downloadTimeout = Duration(minutes: 5);

  /// 单个文件下载失败重试次数（超时/网络抖动自动重试）。
  static const _downloadRetries = 3;

  /// 按 hash 下载到目标路径（API 代理下载），父目录自动创建。
  ///
  /// 失败自动重试 [_downloadRetries] 次（指数退避：1s/2s/4s），
  /// 每次重试前清理半截文件；全部失败抛出最后一次错误。
  /// [onProgress]：0.0–1.0 下载进度。
  Future<void> downloadFile({
    required String hash,
    required String destPath,
    void Function(double progress)? onProgress,
  }) async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final file = File(destPath);
    await file.parent.create(recursive: true);

    Object? lastError;
    for (var attempt = 1; attempt <= _downloadRetries; attempt++) {
      // 重试前清理半截文件，避免下次误判为"已存在"
      if (await file.exists()) {
        try {
          await file.delete();
        } catch (_) {}
      }
      try {
        await _dio.download(
          '$url/api/v1/files/download?hash=$hash',
          destPath,
          options: (await _authOptions()).copyWith(
            receiveTimeout: _downloadTimeout,
            sendTimeout: _downloadTimeout,
          ),
          onReceiveProgress: (received, total) {
            onProgress?.call(total > 0 ? (received / total).clamp(0.0, 1.0) : 0);
          },
        );
        // 校验落盘大小与声明一致（内容寻址：防半截/损坏文件）
        if (await file.exists() && file.lengthSync() > 0) {
          onProgress?.call(1);
          return;
        }
        lastError = StateError('下载文件为空: $hash');
      } catch (e) {
        lastError = e;
        if (attempt < _downloadRetries) {
          AppLog.w('下载失败($hash) 第 $attempt 次，重试中: $e');
          await Future<void>.delayed(
            Duration(seconds: 1 << (attempt - 1)), // 1s, 2s, 4s
          );
        }
      }
    }
    throw lastError ?? StateError('下载失败: $hash');
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
  /// 单文件失败隔离：失败文件记录后继续，不中断整批（健壮性）。
  Future<List<BookFileItem>> ensureUploaded(
    List<BookFileItem> files, {
    void Function(double progress)? onProgress,
    void Function(String relPath, Object error)? onFileError,
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
      try {
        await uploadFile(path: f.absPath, hash: f.hash, size: f.size);
      } catch (e) {
        onFileError?.call(f.relPath, e);
        done++;
        continue; // 失败隔离，不中断整批
      }
      done++;
      onProgress?.call(done / files.length);
    }
    return files;
  }

  /// §2.1.3 整本书上传到服务器（B 接口）：init（保留本地 uuid + 拿 pending）→
  /// 逐文件分片上传 → 每文件 done 标记 → 全部完成 complete（服务端落库）。
  ///
  /// 返回 (uuid, 成功文件数, 失败文件数, 服务器 revision)。失败文件数 > 0 时书未
  /// complete，调用方可提示手动重试；revision = 整本落库后的服务器版本号
  /// （客户端回填 sync_state 作乐观锁基准，§2.1.5）。
  Future<(String, int, int, int)> uploadBookToServer({
    required String uuid, // 本地书 uuid（§6 方案1：保留）
    required String name,
    required List<BookFileItem> files,
    void Function(String relPath, double progress)? onFileProgress,
  }) async {
    final url = await _settings.getString(SyncSettings.serverUrl);

    // 1. init：上报文件清单，服务器保留本地 uuid + 返回待上传
    final init = await _dio.post<Map<String, dynamic>>(
      '$url/api/v1/upload/init',
      data: BookUploadInitRequest(
        books: [
          BookUploadInitBook(
            uuid: uuid,
            clientId: 'local',
            name: name,
            files: [
              for (final f in files)
                BookFileMeta(relPath: f.relPath, hash: f.hash, size: f.size),
            ],
          ),
        ],
      ).toJson(),
      options: await _authOptions(),
    );
    final initResp = BookUploadInitResponse.fromJson(init.data ?? {});
    if (initResp.books.isEmpty || initResp.books.first.uuid.isEmpty) {
      throw StateError('上传初始化失败: 未返回 uuid');
    }
    final serverUuid = initResp.books.first.uuid;
    final pending = initResp.books.first.pendingFiles;

    // 2. 逐文件上传（仅 pending）+ done 标记
    var okCount = 0;
    var failCount = 0;
    for (final f in files) {
      // pending 里才有才需要传；已在服务器（跨设备已传）的跳过
      final isPending = pending.any((p) => p.hash == f.hash);
      if (!isPending) {
        okCount++;
        continue;
      }
      try {
        await uploadFile(
          path: f.absPath,
          hash: f.hash,
          size: f.size,
          onProgress: (p) => onFileProgress?.call(f.relPath, p),
        );
        // 标记文件 done（服务端 book_upload_file 状态推进）
        await _dio.post<Map<String, dynamic>>(
          '$url/api/v1/upload/file/$serverUuid/done?hash=${f.hash}',
          options: await _authOptions(),
        );
        okCount++;
      } catch (e) {
        failCount++;
        AppLog.e('书上传文件失败 $name/${f.relPath}: $e', tag: 'UPLOAD');
      }
    }

    // 3. complete（全部成功才触发；服务端校验全部 done 后落库 current_book）
    var revision = 0;
    if (failCount == 0) {
      final comp = await _dio.post<Map<String, dynamic>>(
        '$url/api/v1/upload/complete/$serverUuid',
        options: await _authOptions(),
      );
      final resp = BookUploadCompleteResponse.fromJson(comp.data ?? {});
      if (!resp.done) {
        // 服务端判未完成（如 pending 未清）→ 当失败处理
        failCount = files.length - okCount;
      } else {
        revision = resp.revision;
      }
    }
    return (serverUuid, okCount, failCount, revision);
  }

  /// §2.1.3 整本书上传（B 接口）并同时向组任务明细/行级进度上报（§0 复用）。
  ///
  /// 细节：
  /// - 组内注册书 → 逐文件 syncing/done（onFileProgress 驱动）→ 整本收尾
  ///   [SyncOpDetailWriter.finishBook]（失败文件标 failed，书标 failed）。
  /// - 行级进度 [rowProgress] 按文件序推进 currentPage（跨过"服务器已有跳过"的文件）。
  /// - 返回 (uuid, 成功数, 失败数, 服务器 revision)，同 [uploadBookToServer]。
  Future<(String, int, int, int)> uploadBookToServerWithDetail({
    required SyncOpDetailWriter detail,
    required SyncOpProgressCallback rowProgress,
    required int currentBook,
    required int totalBooks,
    required String uuid,
    required String name,
    required List<BookFileItem> files,
  }) async {
    detail.book(uuid, name, [for (final f in files) f.relPath]);
    final indexByRelPath = {
      for (var i = 0; i < files.length; i++) files[i].relPath: i,
    };
    var row = 0; // 已推进到的文件序（进度回调驱动）
    final (serverUuid, ok, fail, revision) = await uploadBookToServer(
      uuid: uuid,
      name: name,
      files: files,
      onFileProgress: (relPath, p) {
        final i = (indexByRelPath[relPath] ?? 0) + 1;
        if (p >= 1) {
          detail.fileDone(uuid, relPath);
          row = i;
        } else {
          detail.fileSyncing(uuid, relPath, progress: p.clamp(0.0, 1.0));
        }
        rowProgress(SyncOpProgress(
          currentBook: currentBook,
          totalBooks: totalBooks,
          currentPage: row,
          totalPages: files.length,
        ));
      },
    );
    detail.finishBook(uuid, ok: fail == 0);
    return (serverUuid, ok, fail, revision);
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
