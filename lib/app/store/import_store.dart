import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:tele_book/app/service/book_service.dart';
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
class ImportStore extends ChangeNotifier {
  final ImportService _importService;
  final BookService _bookService;
  final List<ImportGroup> _groups = [];

  ImportStore(this._importService, this._bookService);

  /// 获取所有导入组
  List<ImportGroup> get groups => List.unmodifiable(_groups);

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

  /// 构建导入组
  Future<ImportGroup> buildImportGroup({
    required String name,
    required ImportType type,
    required List<File> files,
  }) {
    return _importService.buildImportGroup(name: name, type: type, files: files);
  }

  /// 添加导入组到列表
  void addImportGroup(ImportGroup group) {
    _groups.insert(0, group);
    notifyListeners();
  }

  /// 开始导入，回调直接更新 group/task 状态
  Future<void> startImport(ImportGroup group) {
    return _importService.startImport(
      group,
      onTaskStatus: (taskId, status, error, distSubPath) {
        final task = _getTaskById(group, taskId);
        if (task != null) {
          task.status.value = status;
          task.error = error;
          if (distSubPath != null) task.distSubPath.value = distSubPath;
        }
      },
      onGroupStatus: (status) {
        group.status.value = status;
      },
      onBookSave: (name, localPaths) async {
        await _bookService.insertWithPaths(name: name, localPaths: localPaths);
        notifyListeners();
      },
    );
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
    for (final group in _groups) {
      group.dispose();
    }
    _groups.clear();

    super.dispose();
  }
}
