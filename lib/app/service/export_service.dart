import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dk_util/dk_util.dart';
import 'package:flutter/foundation.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/util/file_util.dart';
import 'package:tele_book/app/util/pick_file_util.dart';

enum ExportStatus {
  pending('待处理'),
  running('导出中'),
  success('导出成功'),
  failed('导出失败');

  final String displayName;
  const ExportStatus(this.displayName);
}

/// 导出服务 - 纯业务逻辑层，无状态流
class ExportService {
  final AppDatabase db;

  ExportService(this.db);

  Future<BookTableData?> getBookById(int bookId) => db.bookDao.getById(bookId);

  /// 让调用方选择目录
  Future<String?> pickExportDir() => PickFileUtil.pickDirectory();

  /// 运行导出，通过回调通知 Store 更新进度和状态
  Future<void> runExport(
    BookTableData data,
    String exportDir, {
    void Function(int progress, int total)? onProgress,
    void Function(ExportStatus status, String? error, String? outputPath)?
    onStatus,
  }) async {
    try {
      onStatus?.call(ExportStatus.running, null, null);

      final appDirPath = await FileUtil.getAppDocumentsPath();
      final List<MapEntry<String, Uint8List>> fileContents = [];
      int index = 1;
      int notFoundCount = 0;
      final totalFiles = data.localPaths.length;

      for (final path in data.localPaths) {
        final fullPath = "$appDirPath/$path";
        if (await FileUtil.fileExistsAbsolute(fullPath)) {
          final fileName = "${FileUtil.formatExportIndex(index)}.jpg";
          final fileBytes = await File(fullPath).readAsBytes();
          fileContents.add(MapEntry(fileName, fileBytes));
          index++;
        } else {
          notFoundCount++;
        }
        onProgress?.call(index + notFoundCount - 1, totalFiles);
      }

      DKLog.s('📊 导出统计: 成功 ${fileContents.length} 个，缺失 $notFoundCount 个');

      if (fileContents.isEmpty) {
        onStatus?.call(ExportStatus.failed, '没有可导出的文件', null);
        return;
      }

      final zipPath = await FileUtil.generateNonConflictingPath(
        exportDir,
        '${FileUtil.sanitizeFileName(data.name)}.zip',
      );

      final zipBytes = await compute(_compressFiles, fileContents);
      await File(zipPath).writeAsBytes(zipBytes);

      onStatus?.call(ExportStatus.success, null, zipPath);
    } catch (e) {
      onStatus?.call(ExportStatus.failed, e.toString(), null);
    }
  }
}

Uint8List _compressFiles(List<MapEntry<String, Uint8List>> files) {
  final archive = Archive();
  for (final entry in files) {
    archive.addFile(ArchiveFile(entry.key, entry.value.length, entry.value));
  }
  return Uint8List.fromList(ZipEncoder().encode(archive));
}
