import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tele_book/app/service/export_service.dart';

enum ExportStatus {
  pending('待处理'),
  running('导出中'),
  success('导出成功'),
  failed('导出失败');

  final String displayName;
  const ExportStatus(this.displayName);
}

/// 导出记录，使用 ValueNotifier 实现响应式更新
class ExportRecord {
  final String id;
  final int? bookId;
  final String name;
  final DateTime createdAt;

  // 响应式字段
  final ValueNotifier<ExportStatus> status = ValueNotifier(ExportStatus.pending);
  final ValueNotifier<int> progress = ValueNotifier(0); // 已导出的文件数
  int total = 0; // 总文件数
  String? outputPath;
  String? error;

  ExportRecord({
    required this.id,
    this.bookId,
    required this.name,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// 清理资源
  void dispose() {
    status.dispose();
    progress.dispose();
  }
}

/// 导出状态管理中心
/// 监听 ExportService 的事件流，管理所有导出记录
class ExportStore extends ChangeNotifier {
  final ExportService _exportService;
  final List<ExportRecord> _records = [];
  StreamSubscription? _recordSub;
  StreamSubscription? _progressSub;
  StreamSubscription? _statusSub;

  ExportStore(this._exportService) {
    _listenToService();
  }

  /// 获取所有导出记录
  List<ExportRecord> get records => List.unmodifiable(_records);

  /// 监听 Service 的事件流
  void _listenToService() {
    // 监听新记录创建
    _recordSub = _exportService.recordStream.listen((record) {
      _records.insert(0, record); // 新记录插入到顶部
      notifyListeners();
    });

    // 监听进度更新
    _progressSub = _exportService.progressStream.listen((event) {
      final record = getRecordById(event.recordId);
      if (record != null) {
        record.progress.value = event.progress;
        record.total = event.total;
        // 不需要 notifyListeners，因为是 ValueNotifier
      }
    });

    // 监听状态变化
    _statusSub = _exportService.statusStream.listen((event) {
      final record = getRecordById(event.recordId);
      if (record != null) {
        record.status.value = event.status;
        record.error = event.error;
        // 不需要 notifyListeners，因为是 ValueNotifier
      }
    });
  }

  /// 根据ID查找记录
  ExportRecord? getRecordById(String id) {
    try {
      return _records.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 触发重新导出（委托给 Service）
  Future<void> exportBookById(int bookId) {
    return _exportService.exportBookById(bookId);
  }

  /// 清空所有记录
  void clearRecords() {
    for (final record in _records) {
      record.dispose();
    }
    _records.clear();
    notifyListeners();
  }

  /// 删除指定记录
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
    _recordSub?.cancel();
    _progressSub?.cancel();
    _statusSub?.cancel();
    for (final record in _records) {
      record.dispose();
    }
    _records.clear();
    super.dispose();
  }
}