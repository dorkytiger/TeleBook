import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tele_book/app/service/import_service.dart';

enum ImportStatus { pending, running, success, failed }

enum ImportType { zip, folderZip, folder, folderWithSubfolders, pdf }

/// 导入组
class ImportGroup {
  final String id;
  final String name; // 书名
  final ImportType type;
  final DateTime createdAt;

  // 可选：如果导入成功后创建了书籍，记录书籍ID
  int? bookId;

  // 响应式属性
  final tasks = ValueNotifier(<ImportTask>[]);
  final status = ValueNotifier(ImportStatus.pending);

  ImportGroup({
    required this.id,
    required this.name,
    required this.type,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get completedCount =>
      tasks.value.where((t) => t.status.value == ImportStatus.success).length;

  int get totalCount => tasks.value.length;

  int get failedCount =>
      tasks.value.where((t) => t.status.value == ImportStatus.failed).length;

  double get groupProgress => totalCount == 0 ? 0 : completedCount / totalCount;

  void dispose() {
    tasks.dispose();
    status.dispose();
  }
}

/// 导入任务
class ImportTask {
  final String id;
  final String groupId; // 所属导入组ID
  final String filePath; // 待导入文件路径
  final distSubPath = ValueNotifier(''); // 导入后文件路径（如果有）
  final DateTime createdAt;

  // 响应式属性
  final status = ValueNotifier(ImportStatus.pending);
  String? error;

  ImportTask({
    required this.id,
    required this.groupId,
    required this.filePath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  void dispose() {
    distSubPath.dispose();
    status.dispose();
  }
}

/// 导入状态管理中心
/// 监听 ImportService 的事件流，管理所有导入组和任务
class ImportStore extends ChangeNotifier {
  final ImportService _importService;
  final List<ImportGroup> _groups = [];

  StreamSubscription? _groupSub;
  StreamSubscription? _taskStatusSub;
  StreamSubscription? _groupStatusSub;
  StreamSubscription? _bookSaveSub;

  ImportStore(this._importService) {
    _listenToService();
  }

  /// 获取所有导入组
  List<ImportGroup> get groups => List.unmodifiable(_groups);

  /// 监听 Service 的事件流
  void _listenToService() {
    // 监听新导入组创建
    _groupSub = _importService.groupStream.listen((group) {
      _groups.insert(0, group); // 新组插入到顶部
      notifyListeners();
    });

    // 监听任务状态更新
    _taskStatusSub = _importService.taskStatusStream.listen((event) {
      final group = getGroupById(event.groupId);
      if (group != null) {
        final task = _getTaskById(group, event.taskId);
        if (task != null) {
          task.status.value = event.status;
          task.error = event.error;
          if (event.distSubPath != null) {
            task.distSubPath.value = event.distSubPath!;
          }
          // ValueNotifier 会自动通知监听者，不需要手动 notifyListeners
        }
      }
    });

    // 监听导入组状态更新
    _groupStatusSub = _importService.groupStatusStream.listen((event) {
      final group = getGroupById(event.groupId);
      if (group != null) {
        group.status.value = event.status;
        // ValueNotifier 会自动通知监听者
      }
    });

    // 监听书籍保存请求（这个可以由外部的 BookService 监听并处理）
    _bookSaveSub = _importService.bookSaveStream.listen((event) {
      // ImportStore 可以记录 bookId 等信息
      // 实际的书籍保存应该由 BookService 处理
    });
  }

  /// 根据ID查找导入组
  ImportGroup? getGroupById(String id) {
    try {
      return _groups.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 根据ID查找任务
  ImportTask? _getTaskById(ImportGroup group, String taskId) {
    try {
      return group.tasks.value.firstWhere((t) => t.id == taskId);
    } catch (_) {
      return null;
    }
  }

  /// 删除指定导入组
  void removeGroup(String id) {
    final group = getGroupById(id);
    if (group != null) {
      _groups.remove(group);
      group.dispose();
      notifyListeners();
    }
  }

  /// 清空所有导入组
  void clearGroups() {
    for (final group in _groups) {
      group.dispose();
    }
    _groups.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _groupSub?.cancel();
    _taskStatusSub?.cancel();
    _groupStatusSub?.cancel();
    _bookSaveSub?.cancel();

    for (final group in _groups) {
      group.dispose();
    }
    _groups.clear();

    super.dispose();
  }
}
