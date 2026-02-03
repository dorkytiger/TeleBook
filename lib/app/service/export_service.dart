import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dk_util/dk_util.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/util/pick_file_util.dart';
import 'package:tele_book/app/db/app_database.dart';

enum ExportStatus {
  pending('待处理'),
  running('导出中'),
  success('导出成功'),
  failed('导出失败');

  final String displayName;
  const ExportStatus(this.displayName);
}

class ExportRecord {
  final String id;
  final int? bookId;
  final String name;
  final DateTime createdAt;

  final status = ExportStatus.pending.obs;
  final progress = 0.obs; // 已导出的文件数
  int total = 0; // 总文件数
  String? outputPath;
  String? error;

  ExportRecord({
    required this.id,
    this.bookId,
    required this.name,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class ExportService extends GetxService {
  final appDatabase = Get.find<AppDatabase>();
  final records = <ExportRecord>[].obs;

  /// Start export for a single book. If [exportDir] is null, will prompt user to pick.
  Future<ExportRecord?> exportBookById(int bookId, {String? exportDir}) async {
    final book = await (appDatabase.bookTable.select()
          ..where((t) => t.id.equals(bookId)))
        .getSingleOrNull();
    if (book == null) return null;
    return exportBook(book, exportDir: exportDir);
  }

  Future<ExportRecord?> exportBook(BookTableData data, {String? exportDir}) async {
    if (data.localPaths.isEmpty) return null;

    final dir = exportDir ?? await PickFileUtil.pickDirectory();
    if (dir == null) return null;

    final record = ExportRecord(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      bookId: data.id,
      name: data.name,
    );

    records.insert(0, record);

    // Run export asynchronously
    unawaited(_runExport(record, data, dir));

    return record;
  }

  /// Export multiple books sequentially. If exportDir is null, will prompt once.
  Future<List<ExportRecord>> exportMultiple(List<BookTableData> books, {String? exportDir}) async {
    if (books.isEmpty) return [];

    final dir = exportDir ?? await PickFileUtil.pickDirectory();
    if (dir == null) return [];

    final result = <ExportRecord>[];
    for (final book in books) {
      final r = ExportRecord(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        bookId: book.id,
        name: book.name,
      );
      records.insert(0, r);
      result.add(r);
      await _runExport(r, book, dir);
    }

    return result;
  }

  Future<void> _runExport(ExportRecord record, BookTableData data, String exportDir) async {
    try {
      record.status.value = ExportStatus.running;
      final appDir = await getApplicationDocumentsDirectory();

      // Collect existing files
      final List<MapEntry<String, Uint8List>> fileContents = [];
      int index = 1;
      int notFoundCount = 0;

      for (final path in data.localPaths) {
        final fullPath = "${appDir.path}/$path";
        final file = File(fullPath);
        final exists = await file.exists();
        if (exists) {
          final fileName = "${index.toString().padLeft(8, '0')}.jpg";
          final fileBytes = await file.readAsBytes();
          fileContents.add(MapEntry(fileName, fileBytes));
          index++;
          record.progress.value = fileContents.length;
        } else {
          notFoundCount++;
        }
      }

      record.total = fileContents.length;

      // debug info
      DKLog.s('📊 导出统计: 成功 ${fileContents.length} 个，缺失 $notFoundCount 个');

      if (fileContents.isEmpty) {
        record.status.value = ExportStatus.failed;
        record.error = '没有可导出的文件';
        return;
      }

      final timestamp = DateTime.now().toString().replaceAll(RegExp(r'[:\s\.]'), '_');
      final sanitizedName = data.name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
      final zipFileName = '${sanitizedName}_$timestamp.zip';
      final zipPath = p.join(exportDir, zipFileName);

      // compress in isolate
      final zipBytes = await compute(_compressFiles, fileContents);

      final zipFile = File(zipPath);
      await zipFile.writeAsBytes(zipBytes);

      record.outputPath = zipPath;
      record.status.value = ExportStatus.success;
    } catch (e) {
      record.status.value = ExportStatus.failed;
      record.error = e.toString();
    }
  }
}

// top-level function to be run in an isolate
Uint8List _compressFiles(List<MapEntry<String, Uint8List>> files) {
  final archive = Archive();

  for (final entry in files) {
    final archiveFile = ArchiveFile(
      entry.key,
      entry.value.length,
      entry.value,
    );
    archive.addFile(archiveFile);
  }

  final zipEncoder = ZipEncoder();
  return Uint8List.fromList(zipEncoder.encode(archive));
}