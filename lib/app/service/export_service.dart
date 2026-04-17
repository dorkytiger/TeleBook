import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dk_util/dk_util.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/store/export_store.dart';
import 'package:tele_book/app/util/pick_file_util.dart';
import 'package:tele_book/app/db/app_database.dart';

/// 导出进度事件
typedef ExportProgressEvent = ({
  String recordId,
  int progress, // 已处理文件数
  int total, // 总文件数
});

/// 导出状态变化事件
typedef ExportStatusEvent = ({
  String recordId,
  ExportStatus status,
  String? error, // 仅在失败时有值
});

/// 导出记录创建事件
typedef ExportRecordEvent = ExportRecord;

/// 导出服务 - 纯业务逻辑层
/// 通过广播流发送事件，不依赖任何 Store
/// Store 可以监听这些流来管理状态
class ExportService {
  final AppDatabase db;

  ExportService(this.db);

  // 广播流控制器 - 用于向多个订阅者发送事件
  final _recordCtrl = StreamController<ExportRecordEvent>.broadcast();
  final _progressCtrl = StreamController<ExportProgressEvent>.broadcast();
  final _statusCtrl = StreamController<ExportStatusEvent>.broadcast();

  /// 记录创建事件流（Store 可以监听此流来添加记录）
  Stream<ExportRecordEvent> get recordStream => _recordCtrl.stream;

  /// 进度更新事件流
  Stream<ExportProgressEvent> get progressStream => _progressCtrl.stream;

  /// 状态变化事件流
  Stream<ExportStatusEvent> get statusStream => _statusCtrl.stream;

  /// 释放资源
  void dispose() {
    _recordCtrl.close();
    _progressCtrl.close();
    _statusCtrl.close();
  }

  /// Start export for a single book. If [exportDir] is null, will prompt user to pick.
  Future<ExportRecord?> exportBookById(int bookId, {String? exportDir}) async {
    final book = await db.bookDao.getById(bookId);
    if (book == null) return null;
    return exportBook(book, exportDir: exportDir);
  }

  Future<ExportRecord?> exportBook(
    BookTableData data, {
    String? exportDir,
  }) async {
    if (data.localPaths.isEmpty) return null;

    final dir = exportDir ?? await PickFileUtil.pickDirectory();
    if (dir == null) return null;

    final record = ExportRecord(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      bookId: data.id,
      name: data.name,
    );

    // 广播记录创建事件
    _recordCtrl.add(record);

    // 广播初始进度
    _progressCtrl.add((
      recordId: record.id,
      progress: 0,
      total: data.localPaths.length,
    ));

    // Run export asynchronously
    unawaited(_runExport(record, data, dir));

    return record;
  }

  /// Export multiple books. First add all to queue, then run exports asynchronously.
  Future<List<ExportRecord>> exportMultiple(
    List<BookTableData> books, {
    String? exportDir,
  }) async {
    if (books.isEmpty) return [];

    final dir = exportDir ?? await PickFileUtil.pickDirectory();
    if (dir == null) return [];

    final result = <ExportRecord>[];

    // First, create all records and broadcast events
    for (final book in books) {
      final r = ExportRecord(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        bookId: book.id,
        name: book.name,
      );
      result.add(r);

      // 广播每个记录创建事件
      _recordCtrl.add(r);

      // 广播初始进度
      _progressCtrl.add((
        recordId: r.id,
        progress: 0,
        total: book.localPaths.length,
      ));
    }

    // Then run all exports asynchronously (non-blocking)
    for (int i = 0; i < books.length; i++) {
      unawaited(_runExport(result[i], books[i], dir));
    }

    return result;
  }

  Future<void> _runExport(
    ExportRecord record,
    BookTableData data,
    String exportDir,
  ) async {
    try {
      // 广播状态变化：运行中
      _statusCtrl.add((
        recordId: record.id,
        status: ExportStatus.running,
        error: null,
      ));

      final appDir = await getApplicationDocumentsDirectory();

      // Collect existing files
      final List<MapEntry<String, Uint8List>> fileContents = [];
      int index = 1;
      int notFoundCount = 0;
      final totalFiles = data.localPaths.length;

      for (final path in data.localPaths) {
        final fullPath = "${appDir.path}/$path";
        final file = File(fullPath);
        final exists = await file.exists();
        if (exists) {
          final fileName = "${index.toString().padLeft(8, '0')}.jpg";
          final fileBytes = await file.readAsBytes();
          fileContents.add(MapEntry(fileName, fileBytes));
          index++;
        } else {
          notFoundCount++;
        }

        // 广播进度更新
        _progressCtrl.add((
          recordId: record.id,
          progress: index + notFoundCount - 1,
          total: totalFiles,
        ));
      }

      // debug info
      DKLog.s('📊 导出统计: 成功 ${fileContents.length} 个，缺失 $notFoundCount 个');

      if (fileContents.isEmpty) {
        // 广播失败状态
        _statusCtrl.add((
          recordId: record.id,
          status: ExportStatus.failed,
          error: '没有可导出的文件',
        ));
        return;
      }

      final sanitizedName = data.name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');

      // 无后缀优先，冲突时加 (1)(2)...
      String zipFileName = '$sanitizedName.zip';
      String zipPath = p.join(exportDir, zipFileName);
      int suffix = 1;
      while (await File(zipPath).exists()) {
        zipFileName = '$sanitizedName($suffix).zip';
        zipPath = p.join(exportDir, zipFileName);
        suffix++;
      }

      // compress in isolate
      final zipBytes = await compute(_compressFiles, fileContents);

      final zipFile = File(zipPath);
      await zipFile.writeAsBytes(zipBytes);

      // 保存输出路径到 record（这个可以保留，因为是最终结果）
      record.outputPath = zipPath;

      // 广播成功状态
      _statusCtrl.add((
        recordId: record.id,
        status: ExportStatus.success,
        error: null,
      ));
    } catch (e) {
      // 广播失败状态
      _statusCtrl.add((
        recordId: record.id,
        status: ExportStatus.failed,
        error: e.toString(),
      ));
    }
  }
}

// top-level function to be run in an isolate
Uint8List _compressFiles(List<MapEntry<String, Uint8List>> files) {
  final archive = Archive();

  for (final entry in files) {
    final archiveFile = ArchiveFile(entry.key, entry.value.length, entry.value);
    archive.addFile(archiveFile);
  }

  final zipEncoder = ZipEncoder();
  return Uint8List.fromList(zipEncoder.encode(archive));
}
