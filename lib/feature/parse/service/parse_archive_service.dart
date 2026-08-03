import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/util/failure_util.dart';
import 'package:tele_book/core/util/result_util.dart';
import 'package:tele_book/feature/parse/model/parse_batch_archive_vo.dart';
import 'package:uuid/uuid.dart';
import 'package:archive/archive_io.dart';

final parseArchiveServiceProvider = Provider((ref) => ParseArchiveService());

class ParseArchiveService {
  Future<Result<List<String>>> parseImagePaths(List<String> imagePaths) async {
    try {
      final images =
          imagePaths.where((path) => _isImageFileStatic(path)).toList()..sort();
      return Result.success(images);
    } catch (e, st) {
      return Result.failure(
        BusinessFailure(message: "解析图片文件失败", details: e, stackTrace: st),
      );
    }
  }

  Future<Result<List<ParseBatchArchiveVo>>> _parseBatchArchivePaths(
    List<String> archivePaths,
    Function(int total) onStart,
    Function(int count) onProgress, {
    void Function(String currentName)? onCurrentItemChanged,
    void Function(int current, int total)? onCurrentItemProgress,
  }) async {
    try {
      final filteredPaths =
          archivePaths
              .where((path) => path.toLowerCase().endsWith('.zip'))
              .toList()
            ..sort();

      onStart(filteredPaths.length);

      final results = <ParseBatchArchiveVo>[];
      for (var index = 0; index < filteredPaths.length; index++) {
        final path = filteredPaths[index];
        onCurrentItemChanged?.call(_baseName(path));
        onCurrentItemProgress?.call(0, 2);

        // 每处理一个文件，让出事件循环，让 UI / GC 有机会运行
        await Future.delayed(Duration.zero);

        final parseResult = await parseArchive(
          path,
          onProgress: (current, total) {
            onCurrentItemProgress?.call(current, total);
          },
        );
        if (parseResult.isSuccess) {
          results.add(
            ParseBatchArchiveVo(
              name: path.split(Platform.pathSeparator).last,
              tempPaths: parseResult.data!,
            ),
          );
          onProgress(index + 1);
        } else {
          throw Exception(parseResult.error?.message);
        }
      }
      return Result.success(results);
    } catch (e, st) {
      return Result.failure(
        BusinessFailure(message: "批量解析压缩包失败", details: e, stackTrace: st),
      );
    }
  }

  // ── 单文件夹解析（只收集路径，不读取文件内容）──────────
  Future<Result<List<String>>> parseImageFolder(String folderPath) async {
    try {
      final dir = Directory(folderPath);
      if (!await dir.exists()) {
        throw FileSystemException("目录不存在", folderPath);
      }
      // compute: 把路径扫描放到后台 Isolate，不阻塞主线程
      final imagePaths = await compute(_collectImagePathsSync, folderPath);
      return Result.success(imagePaths);
    } catch (e, st) {
      return Result.failure(
        BusinessFailure(message: "解析图片文件夹失败", details: e, stackTrace: st),
      );
    }
  }

  // ── 单压缩包解析 ──────────────────────────────────────
  Future<Result<List<String>>> parseArchive(
    String archivePath, {
    void Function(int current, int total)? onProgress,
  }) async {
    try {
      final tempOutputDir =
          "${GlobalConfig.appTempDir.path}/${const Uuid().v4()}";
      onProgress?.call(0, 2);

      // ① 解压放后台 Isolate（最重，可能 OOM，独立内存空间更安全）
      await compute(_extractInBackground, [archivePath, tempOutputDir]);
      onProgress?.call(1, 2);

      // ② 扫描解压后的目录，也放后台 Isolate
      final imagePaths = await compute(_collectImagePathsSync, tempOutputDir);
      onProgress?.call(2, 2);

      return Result.success(imagePaths);
    } catch (e, st) {
      return Result.failure(
        BusinessFailure(message: "解析压缩包失败", details: e, stackTrace: st),
      );
    }
  }

  // ── 批量压缩包解析 ────────────────────────────────────
  Future<Result<List<ParseBatchArchiveVo>>> parseBatchArchives(
    String archiveDirPath,
    Function(int total) onStart,
    Function(int count) onProgress, {
    void Function(String currentName)? onCurrentItemChanged,
    void Function(int current, int total)? onCurrentItemProgress,
  }) async {
    try {
      final archiveDir = Directory(archiveDirPath);
      if (!await archiveDir.exists()) {
        throw FileSystemException("目录不存在", archiveDirPath);
      }

      // 用异步 list，避免 listSync 阻塞主线程
      final archivePaths = await archiveDir
          .list()
          .where((e) => e is File && e.path.toLowerCase().endsWith('.zip'))
          .map((e) => e.path)
          .toList();

      return _parseBatchArchivePaths(
        archivePaths,
        onStart,
        onProgress,
        onCurrentItemChanged: onCurrentItemChanged,
        onCurrentItemProgress: onCurrentItemProgress,
      );
    } catch (e, st) {
      return Result.failure(
        BusinessFailure(message: "批量解析压缩包失败", details: e, stackTrace: st),
      );
    }
  }

  Future<Result<List<ParseBatchArchiveVo>>> parseBatchArchivesFromPaths(
    List<String> archivePaths,
    Function(int total) onStart,
    Function(int count) onProgress, {
    void Function(String currentName)? onCurrentItemChanged,
    void Function(int current, int total)? onCurrentItemProgress,
  }) {
    return _parseBatchArchivePaths(
      archivePaths,
      onStart,
      onProgress,
      onCurrentItemChanged: onCurrentItemChanged,
      onCurrentItemProgress: onCurrentItemProgress,
    );
  }

  // ── 批量文件夹解析 ────────────────────────────────────
  Future<Result<List<ParseBatchArchiveVo>>> parseBatchImageFolders(
    String parentDirPath,
    Function(int total) onStart,
    Function(int count) onProgress, {
    void Function(String currentName)? onCurrentItemChanged,
    void Function(int current, int total)? onCurrentItemProgress,
  }) async {
    try {
      final parentDir = Directory(parentDirPath);
      if (!await parentDir.exists()) {
        throw FileSystemException("目录不存在", parentDirPath);
      }

      // 遍历父目录下的所有子文件夹（不包含父目录自身）
      final folders = await compute(
        _collectSubDirectoryPathsSync,
        parentDirPath,
      );

      onStart(folders.length);

      final results = <ParseBatchArchiveVo>[];
      for (var index = 0; index < folders.length; index++) {
        final folderPath = folders[index];
        onCurrentItemChanged?.call(_baseName(folderPath));
        onCurrentItemProgress?.call(0, 1);

        // 让出事件循环
        await Future.delayed(Duration.zero);

        // 每个子文件夹仅统计当前文件夹内的图片数量；大于 1 才视作一本书
        final images = await compute(_collectDirectImagePathsSync, folderPath);
        if (images.length > 1) {
          results.add(
            ParseBatchArchiveVo(name: _baseName(folderPath), tempPaths: images),
          );
        }
        onCurrentItemProgress?.call(1, 1);
        onProgress(index + 1);
      }
      return Result.success(results);
    } catch (e, st) {
      return Result.failure(
        BusinessFailure(message: "批量解析图片文件夹失败", details: e, stackTrace: st),
      );
    }
  }

  Future<Result<List<ParseBatchArchiveVo>>> parseBatchImageFoldersFromPaths(
    List<String> imagePaths,
    Function(int total) onStart,
    Function(int count) onProgress, {
    void Function(String currentName)? onCurrentItemChanged,
    void Function(int current, int total)? onCurrentItemProgress,
  }) async {
    try {
      final grouped = <String, List<String>>{};
      for (final path in imagePaths) {
        if (!_isImageFileStatic(path)) continue;
        final parent = _dirName(path);
        grouped.putIfAbsent(parent, () => <String>[]).add(path);
      }

      final keys = grouped.keys.toList()..sort();
      onStart(keys.length);

      final results = <ParseBatchArchiveVo>[];
      for (var index = 0; index < keys.length; index++) {
        final key = keys[index];
        onCurrentItemChanged?.call(key.isEmpty ? '未命名文件夹' : _baseName(key));
        onCurrentItemProgress?.call(0, 1);
        final paths = grouped[key]!..sort();
        if (paths.length > 1) {
          results.add(
            ParseBatchArchiveVo(
              name: key.isEmpty ? _baseName(paths.first) : _baseName(key),
              tempPaths: paths,
            ),
          );
        }
        onCurrentItemProgress?.call(1, 1);
        onProgress(index + 1);
        await Future.delayed(Duration.zero);
      }

      return Result.success(results);
    } catch (e, st) {
      return Result.failure(
        BusinessFailure(message: "批量解析图片文件失败", details: e, stackTrace: st),
      );
    }
  }
}

// ── 顶层函数，供 compute() 在后台 Isolate 中调用 ──────────
// Isolate 中不能访问闭包，必须是 top-level / static
Future<void> _extractInBackground(List<String> args) async {
  final archivePath = args[0];
  final outputDir = args[1];
  await extractFileToDisk(archivePath, outputDir);
}

/// 在后台 Isolate 中扫描目录，返回图片路径列表
List<String> _collectImagePathsSync(String dirPath) {
  final dir = Directory(dirPath);
  final result = <String>[];
  for (final entity in dir.listSync(recursive: true, followLinks: false)) {
    if (entity is File && _isImageFileStatic(entity.path)) {
      result.add(entity.path);
    }
  }
  result.sort();
  return result;
}

List<String> _collectDirectImagePathsSync(String dirPath) {
  final dir = Directory(dirPath);
  final result = <String>[];
  for (final entity in dir.listSync(recursive: false, followLinks: false)) {
    if (entity is File && _isImageFileStatic(entity.path)) {
      result.add(entity.path);
    }
  }
  result.sort();
  return result;
}

List<String> _collectSubDirectoryPathsSync(String dirPath) {
  final dir = Directory(dirPath);
  final result = <String>[];
  for (final entity in dir.listSync(recursive: true, followLinks: false)) {
    if (entity is Directory) {
      result.add(entity.path);
    }
  }
  result.sort();
  return result;
}

bool _isImageFileStatic(String path) {
  final p = path.toLowerCase();
  return p.endsWith('.jpg') ||
      p.endsWith('.jpeg') ||
      p.endsWith('.png') ||
      p.endsWith('.gif') ||
      p.endsWith('.bmp') ||
      p.endsWith('.webp');
}

String _baseName(String path) {
  return path.split(RegExp(r'[\\/]')).last;
}

String _dirName(String path) {
  final normalized = path.replaceAll('\\', '/');
  final index = normalized.lastIndexOf('/');
  if (index <= 0) return '';
  return normalized.substring(0, index);
}
