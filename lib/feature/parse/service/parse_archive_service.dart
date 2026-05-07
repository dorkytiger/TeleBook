import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/util/failure_util.dart';
import 'package:tele_book/core/util/result_util.dart';
import 'package:tele_book/feature/parse/model/parse_batch_archive_vo.dart';
import 'package:uuid/uuid.dart';
import 'package:archive/archive_io.dart';

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
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File && _isImageFileStatic(entity.path)) {
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

class ParseArchiveService {
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
  Future<Result<List<String>>> parseArchive(String archivePath) async {
    try {
      final tempOutputDir = "${GlobalConfig.appTempDir.path}/${const Uuid().v4()}";

      // ① 解压放后台 Isolate（最重，可能 OOM，独立内存空间更安全）
      await compute(_extractInBackground, [archivePath, tempOutputDir]);

      // ② 扫描解压后的目录，也放后台 Isolate
      final imagePaths = await compute(_collectImagePathsSync, tempOutputDir);

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
    Function(int count) onProgress,
  ) async {
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

      onStart(archivePaths.length);

      final results = <ParseBatchArchiveVo>[];
      for (var index = 0; index < archivePaths.length; index++) {
        final path = archivePaths[index];

        // 每处理一个文件，让出事件循环，让 UI / GC 有机会运行
        await Future.delayed(Duration.zero);

        final parseResult = await parseArchive(path);
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

  // ── 批量文件夹解析 ────────────────────────────────────
  Future<Result<List<ParseBatchArchiveVo>>> parseBatchImageFolders(
    String parentDirPath,
    Function(int total) onStart,
    Function(int count) onProgress,
  ) async {
    try {
      final parentDir = Directory(parentDirPath);
      if (!await parentDir.exists()) {
        throw FileSystemException("目录不存在", parentDirPath);
      }

      // 异步扫描子目录列表
      final folders = await parentDir
          .list()
          .where((e) => e is Directory)
          .map((e) => e.path)
          .toList()
        ..sort();

      onStart(folders.length);

      final results = <ParseBatchArchiveVo>[];
      for (var index = 0; index < folders.length; index++) {
        final folderPath = folders[index];

        // 让出事件循环
        await Future.delayed(Duration.zero);

        // 每个子文件夹的图片扫描在后台 Isolate 中跑
        final images = await compute(_collectImagePathsSync, folderPath);
        if (images.isNotEmpty) {
          results.add(
            ParseBatchArchiveVo(
              name: folderPath.split(Platform.pathSeparator).last,
              tempPaths: images,
            ),
          );
        }
        onProgress(index + 1);
      }
      return Result.success(results);
    } catch (e, st) {
      return Result.failure(
        BusinessFailure(message: "批量解析图片文件夹失败", details: e, stackTrace: st),
      );
    }
  }
}


