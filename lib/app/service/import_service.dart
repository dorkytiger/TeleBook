import 'dart:io';

import 'package:dk_util/log/dk_log.dart';
import 'package:tele_book/app/store/import_store.dart';
import 'package:tele_book/app/util/file_util.dart';

/// 导入服务 - 纯业务逻辑层，无状态流
class ImportService {

  int _groupIdCounter = 0;
  int _taskIdCounter = 0;

  String generateGroupId() {
    _groupIdCounter++;
    return "group_${DateTime.now().microsecondsSinceEpoch}_$_groupIdCounter";
  }

  String generateTaskId() {
    _taskIdCounter++;
    return "task_${DateTime.now().microsecondsSinceEpoch}_$_taskIdCounter";
  }

  /// 构建导入组
  Future<ImportGroup> buildImportGroup({
    required String name,
    required ImportType type,
    required List<File> files,
  }) async {
    final groupId = generateGroupId();
    final group = ImportGroup(id: groupId, name: name, type: type);
    final tasks = files.map((file) => ImportTask(
      id: generateTaskId(),
      groupId: groupId,
      filePath: file.path,
    )).toList();
    group.tasks.value = tasks;
    return group;
  }

  /// 开始导入，通过回调通知 Store 更新状态
  Future<void> startImport(
    ImportGroup group, {
    required void Function(
      String taskId,
      ImportStatus status,
      String? error,
      String? distSubPath,
    ) onTaskStatus,
    required void Function(ImportStatus status) onGroupStatus,
    required void Function(String name, List<String> localPaths) onBookSave,
  }) async {
    DKLog.d("开始导入组: ${group.name}, 任务数量: ${group.tasks.value.length}");
    onGroupStatus(ImportStatus.running);

    final tasks = group.tasks.value;
    for (var taskIndex = 0; taskIndex < tasks.length; taskIndex++) {
      final task = tasks[taskIndex];
      DKLog.d("处理任务[$taskIndex]: ${task.id}, filePath: ${task.filePath}");
      onTaskStatus(task.id, ImportStatus.running, null, null);

      try {
        final sourceFile = File(task.filePath);
        if (!await sourceFile.exists()) {
          throw Exception("文件不存在: ${task.filePath}");
        }
        final relativePath = await FileUtil.copyFileToDir(sourceFile, group.id);
        DKLog.d("文件复制成功: $relativePath");
        onTaskStatus(task.id, ImportStatus.success, null, relativePath);
      } catch (e, stack) {
        DKLog.e("导入失败", error: e, stackTrace: stack);
        onTaskStatus(task.id, ImportStatus.failed, e.toString(), null);
      }
    }

    // 收集成功路径
    final successPaths = tasks
        .where((t) =>
            t.status.value == ImportStatus.success &&
            t.distSubPath.value.isNotEmpty)
        .map((t) => t.distSubPath.value)
        .toList();
    final hasFailure = tasks.any((t) => t.status.value == ImportStatus.failed);

    DKLog.d("成功任务数: ${successPaths.length}/${tasks.length}");

    if (successPaths.length == tasks.length) {
      onBookSave(group.name, successPaths);
      onGroupStatus(ImportStatus.success);
      DKLog.d("导入组完成: ${group.name}");
    } else if (hasFailure) {
      onGroupStatus(ImportStatus.failed);
      DKLog.w("导入组有失败任务: ${group.name}");
    } else {
      onGroupStatus(ImportStatus.running);
    }
  }
}
