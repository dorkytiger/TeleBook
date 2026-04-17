import 'package:flutter/foundation.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/service/export_service.dart';

/// 导出记录，使用 ValueNotifier 实现响应式更新
class ExportRecord {
  final String id;
  final int? bookId;
  final String name;
  final DateTime createdAt;

  final ValueNotifier<ExportStatus> status = ValueNotifier(
    ExportStatus.pending,
  );
  final ValueNotifier<int> progress = ValueNotifier(0);
  int total = 0;
  String? outputPath;
  String? error;

  ExportRecord({
    required this.id,
    this.bookId,
    required this.name,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  void dispose() {
    status.dispose();
    progress.dispose();
  }
}

/// 导出状态管理中心
class ExportStore extends ChangeNotifier {
  final ExportService _exportService;
  final List<ExportRecord> _records = [];

  ExportStore(this._exportService);

  List<ExportRecord> get records => List.unmodifiable(_records);

  ExportRecord? getRecordById(String id) {
    try {
      return _records.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 根据书籍 ID 导出（先查书籍再导出）
  Future<ExportRecord?> exportBookById(int bookId, {String? exportDir}) async {
    final book = await _exportService.getBookById(bookId);
    if (book == null) return null;
    return exportBook(book, exportDir: exportDir);
  }

  /// 导出单本书籍
  Future<ExportRecord?> exportBook(
    BookTableData data, {
    String? exportDir,
  }) async {
    if (data.localPaths.isEmpty) return null;
    final dir = exportDir ?? await _exportService.pickExportDir();
    if (dir == null) return null;

    final record = ExportRecord(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      bookId: data.id,
      name: data.name,
    );
    record.total = data.localPaths.length;
    _records.insert(0, record);
    notifyListeners();

    // 异步执行，回调直接更新 record 的 ValueNotifier
    _exportService.runExport(
      data,
      dir,
      onProgress: (p, t) {
        record.progress.value = p;
        record.total = t;
      },
      onStatus: (s, e, path) {
        record.status.value = s;
        record.error = e;
        record.outputPath = path;
      },
    );

    return record;
  }

  /// 批量导出
  Future<void> exportMultiple(
    List<BookTableData> books, {
    String? exportDir,
  }) async {
    if (books.isEmpty) return;
    final dir = exportDir ?? await _exportService.pickExportDir();
    if (dir == null) return;

    for (final book in books) {
      await exportBook(book, exportDir: dir);
    }
  }

  void clearRecords() {
    for (final r in _records) r.dispose();
    _records.clear();
    notifyListeners();
  }

  void removeRecord(String id) {
    final record = getRecordById(id);
    if (record != null) {
      _records.remove(record);
      record.dispose();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    for (final r in _records) r.dispose();
    _records.clear();
    super.dispose();
  }
}
