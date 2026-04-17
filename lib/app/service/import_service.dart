import 'dart:async';
import 'dart:io';

import 'package:dk_util/log/dk_log.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/store/import_store.dart';
import 'package:tele_book/app/util/file_util.dart';

/// 导入组创建事件
typedef ImportGroupEvent = ImportGroup;

/// 导入任务状态更新事件
typedef ImportTaskStatusEvent = ({
  String groupId,
  String taskId,
  ImportStatus status,
  String? error,
  String? distSubPath, // 导入成功后的文件路径
});

/// 导入组状态更新事件
typedef ImportGroupStatusEvent = ({String groupId, ImportStatus status});

/// 书籍保存请求事件（导入完成后）
typedef BookSaveRequestEvent = ({
  String groupId,
  String name,
  List<String> localPaths,
});

/// 导入服务 - 纯业务逻辑层
/// 通过广播流发送事件，不依赖任何 Store
/// Store 可以监听这些流来管理状态
class ImportService {
  final AppDatabase appDatabase;

  ImportService(this.appDatabase);

  // 广播流控制器
  final _groupCtrl = StreamController<ImportGroupEvent>.broadcast();
  final _taskStatusCtrl = StreamController<ImportTaskStatusEvent>.broadcast();
  final _groupStatusCtrl = StreamController<ImportGroupStatusEvent>.broadcast();
  final _bookSaveCtrl = StreamController<BookSaveRequestEvent>.broadcast();

  /// 新导入组创建事件流
  Stream<ImportGroupEvent> get groupStream => _groupCtrl.stream;

  /// 任务状态更新事件流
  Stream<ImportTaskStatusEvent> get taskStatusStream => _taskStatusCtrl.stream;

  /// 导入组状态更新事件流
  Stream<ImportGroupStatusEvent> get groupStatusStream =>
      _groupStatusCtrl.stream;

  /// 书籍保存请求事件流（供其他服务监听，如 BookService）
  Stream<BookSaveRequestEvent> get bookSaveStream => _bookSaveCtrl.stream;

  /// 释放资源
  void dispose() {
    _groupCtrl.close();
    _taskStatusCtrl.close();
    _groupStatusCtrl.close();
    _bookSaveCtrl.close();
  }

  int _groupIdCounter = 0;
  int _taskIdCounter = 0;

  String generateGroupId() {
    final now = DateTime.now();
    _groupIdCounter++;
    return "group_${now.microsecondsSinceEpoch}_$_groupIdCounter";
  }

  String generateTaskId() {
    final now = DateTime.now();
    _taskIdCounter++;
    return "task_${now.microsecondsSinceEpoch}_$_taskIdCounter";
  }

  /// 构建导入组
  Future<ImportGroup> buildImportGroup({
    required String name,
    required ImportType type,
    required List<File> files,
  }) async {
    final groupId = generateGroupId();
    final group = ImportGroup(id: groupId, name: name, type: type);

    final tasks = <ImportTask>[];
    for (var file in files) {
      final taskId = generateTaskId();
      final task = ImportTask(
        id: taskId,
        groupId: groupId,
        filePath: file.path,
      );
      tasks.add(task);
    }

    group.tasks.value = tasks;
    return group;
  }

  /// 添加导入组并广播事件
  void addImportGroup(ImportGroup group) {
    _groupCtrl.add(group);
  }


  /// 开始导入
  Future<void> startImport(ImportGroup group) async {
    DKLog.d("开始导入组: ${group.name}, 任务数量: ${group.tasks.value.length}");

    // 广播组状态变化
    _groupStatusCtrl.add((groupId: group.id, status: ImportStatus.running));

    final tasks = group.tasks.value;
    for (var taskIndex = 0; taskIndex < tasks.length; taskIndex++) {
      final task = tasks[taskIndex];
      DKLog.d("处理任务[$taskIndex]: ${task.id}, filePath: ${task.filePath}");

      // 广播任务状态：运行中
      _taskStatusCtrl.add((
        groupId: group.id,
        taskId: task.id,
        status: ImportStatus.running,
        error: null,
        distSubPath: null,
      ));

      try {
        // 使用 FileUtil 拷贝文件到应用目录
        DKLog.d("开始导入文件: ${task.filePath}");
        final sourceFile = File(task.filePath);
        if (!await sourceFile.exists()) {
          throw Exception("文件不存在: ${task.filePath}");
        }

        // 复制文件到应用目录的 group.id 子目录
        final relativePath = await FileUtil.copyFileToDir(
          sourceFile,
          group.id,
        );

        DKLog.d("任务 ${task.id} distSubPath 已设置: '$relativePath'");

        // 广播任务状态：成功
        _taskStatusCtrl.add((
          groupId: group.id,
          taskId: task.id,
          status: ImportStatus.success,
          error: null,
          distSubPath: relativePath,
        ));

        DKLog.d("文件复制成功: $relativePath");
      } catch (e, stack) {
        DKLog.e("导入失败", error: e, stackTrace: stack);

        // 广播任务状态：失败
        _taskStatusCtrl.add((
          groupId: group.id,
          taskId: task.id,
          status: ImportStatus.failed,
          error: e.toString(),
          distSubPath: null,
        ));
      }
    }

    // 检查所有任务状态
    DKLog.d("所有任务处理完毕，开始检查状态");

    // 收集成功任务的路径
    final successPaths = <String>[];
    bool hasFailure = false;

    for (var task in tasks) {
      if (task.status.value == ImportStatus.success &&
          task.distSubPath.value.isNotEmpty) {
        successPaths.add(task.distSubPath.value);
      } else if (task.status.value == ImportStatus.failed) {
        hasFailure = true;
      }
    }

    DKLog.d("成功任务数: ${successPaths.length}/${tasks.length}");

    // 检查是否所有任务都成功
    if (successPaths.length == tasks.length) {
      // 广播书籍保存请求
      _bookSaveCtrl.add((
        groupId: group.id,
        name: group.name,
        localPaths: successPaths,
      ));

      // 广播组状态：成功
      _groupStatusCtrl.add((groupId: group.id, status: ImportStatus.success));
      DKLog.d("导入组完成: ${group.name}");
    } else if (hasFailure) {
      // 广播组状态：失败
      _groupStatusCtrl.add((groupId: group.id, status: ImportStatus.failed));
      DKLog.w("导入组有失败任务: ${group.name}");
    } else {
      // 广播组状态：运行中（理论上不应该到这）
      _groupStatusCtrl.add((groupId: group.id, status: ImportStatus.running));
      DKLog.d("导入组仍在运行: ${group.name}");
    }
  }
}
