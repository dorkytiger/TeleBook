import 'dart:io';

import 'package:dk_util/log/dk_log.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/event/event_bus.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';

enum ImportStatus { pending, running, success, failed }

enum ImportType { zip, folderZip, folder, folderWithSubfolders, pdf }

class ImportGroup {
  final String id;
  final String name; // 书名
  final ImportType type;
  final DateTime createdAt;

  // 可选：如果导入成功后创建了书籍，记录书籍ID
  int? bookId;

  // 响应式属性
  final tasks = <ImportTask>[].obs;
  final status = ImportStatus.pending.obs;

  ImportGroup({
    required this.id,
    required this.name,
    required this.type,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get completedCount =>
      tasks.where((t) => t.status.value == ImportStatus.success).length;

  int get totalCount => tasks.length;

  int get failedCount =>
      tasks.where((t) => t.status.value == ImportStatus.failed).length;

  double get groupProgress => totalCount == 0 ? 0 : completedCount / totalCount;
}

class ImportTask {
  final String id;
  final String groupId; // 所属导入组ID
  final String filePath; // 待导入文件路径
  final distSubPath = ''.obs; // 导入后文件路径（如果有）
  final DateTime createdAt;

  // 响应式属性
  final status = ImportStatus.pending.obs;
  String? error;

  ImportTask({
    required this.id,
    required this.groupId,
    required this.filePath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class ImportService extends GetxService {
  final _eventBus = Get.find<EventBus>();
  final appDatabase = Get.find<AppDatabase>();
  final groups = <ImportGroup>[].obs;

  // 添加一个新的导入组
  void addImportGroup(ImportGroup group) {
    groups.add(group);
  }

  (int, ImportGroup)? getGroupByIdWithIndex(String id) {
    final index = groups.indexWhere((g) => g.id == id);
    if (index == -1) return null;
    return (index, groups[index]);
  }

  // 或者只返回对象，但确保响应式
  ImportGroup? getGroupById(String id) {
    final index = groups.indexWhere((g) => g.id == id);
    if (index == -1) return null;
    return groups[index]; // 通过索引访问，保持响应式
  }

  // 更新导入任务状态
  void updateTaskStatus(
    String groupId,
    String taskId,
    ImportStatus status, {
    String? error,
  }) {
    final index = groups.indexWhere((g) => g.id == groupId);
    if (index == -1) return;

    final group = groups[index];
    final taskIndex = group.tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    final task = group.tasks[taskIndex];
    task.status.value = status;
    if (error != null) {
      task.error = error;
    }

    // 手动触发响应式更新
    group.tasks.refresh();
  }

  Future<void> startImport(String groupId) async {
    final index = groups.indexWhere((g) => g.id == groupId);
    if (index == -1) {
      DKLog.e("找不到导入组: $groupId");
      return;
    }

    final group = groups[index]; // 通过索引访问，保持响应式

    DKLog.d("开始导入组: ${group.name}, 任务数量: ${group.tasks.length}");
    group.status.value = ImportStatus.running;

    for (var taskIndex = 0; taskIndex < group.tasks.length; taskIndex++) {
      final task = group.tasks[taskIndex]; // 通过索引访问
      DKLog.d("处理任务[$taskIndex]: ${task.id}, filePath: ${task.filePath}");

      task.status.value = ImportStatus.running;

      try {
        //拷贝文件到应用目录
        DKLog.d("开始导入文件: ${task.filePath}");
        final sourceFile = File(task.filePath);
        if (!await sourceFile.exists()) {
          throw Exception("文件不存在: ${task.filePath}");
        }

        final appDir = await getApplicationDocumentsDirectory();
        final distDir = Directory("${appDir.path}/${group.id}");
        if (!await distDir.exists()) {
          await distDir.create(recursive: true);
        }

        final fileName = sourceFile.uri.pathSegments.last;
        final distFile = File("${distDir.path}/$fileName");

        DKLog.d("准备复制: ${sourceFile.path} -> ${distFile.path}");
        await sourceFile.copy(distFile.path);

        // 设置相对路径
        final subPath = "${group.id}/$fileName";
        task.distSubPath.value = subPath;

        DKLog.d("任务 ${task.id} distSubPath 已设置: '${task.distSubPath.value}'");

        task.status.value = ImportStatus.success;
        DKLog.d("文件复制成功: ${distFile.path}");
      } catch (e, stack) {
        DKLog.e("导入失败", error: e, stackTrace: stack);
        task.status.value = ImportStatus.failed;
        task.error = e.toString();
      }
    }

    // 强制刷新任务列表
    group.tasks.refresh();

    // 检查所有任务状态
    DKLog.d("所有任务处理完毕，开始检查状态");
    DKLog.d("成功任务数: ${group.completedCount}/${group.totalCount}");
    DKLog.d("失败任务数: ${group.failedCount}");

    // 打印每个任务的详细信息
    for (var i = 0; i < group.tasks.length; i++) {
      final task = group.tasks[i];
      DKLog.d(
        "任务[$i] - ID: ${task.id}, Status: ${task.status.value}, distSubPath: '${task.distSubPath.value}'",
      );
    }

    // 检查是否所有任务都完成
    if (group.tasks.every((t) => t.status.value == ImportStatus.success)) {
      // 处理数据库
      final localPaths = group.tasks.map((t) => t.distSubPath.value).toList();
      DKLog.t("所有任务完成，准备写入数据库");
      DKLog.t("localPaths 数量: ${localPaths.length}");
      DKLog.t("localPaths 内容: $localPaths");

      if (localPaths.isEmpty || localPaths.any((p) => p.isEmpty)) {
        DKLog.e("警告: localPaths 中存在空值！");
        DKLog.e("详细检查每个任务:");
        for (var task in group.tasks) {
          DKLog.e(
            "  任务 ${task.id}: distSubPath='${task.distSubPath.value}', isEmpty=${task.distSubPath.value.isEmpty}",
          );
        }
      }

      final bookData = BookTableCompanion.insert(
        name: group.name,
        localPaths: localPaths,
      );
      _eventBus.fire(BookAddedEvent(bookData));

      group.status.value = ImportStatus.success;
      DKLog.d("导入组完成: ${group.name}");

      // 刷新书籍列表
      try {
        final bookController = Get.find<BookController>();
        await bookController.fetchBooks();
      } catch (e) {
        DKLog.w("刷新书籍列表失败: $e");
      }
    } else if (group.tasks.any((t) => t.status.value == ImportStatus.failed)) {
      group.status.value = ImportStatus.failed;
      DKLog.w("导入组有失败任务: ${group.name}");
    } else {
      group.status.value = ImportStatus.running; // 仍有任务在运行
      DKLog.d("导入组仍在运行: ${group.name}");
    }
  }

  Future<void> restartImport(String groupId) async {
    final group = getGroupById(groupId);
    if (group != null) {
      // 重置任务状态
      for (var task in group.tasks) {
        task.status.value = ImportStatus.pending;
        task.error = null;
      }
      group.status.value = ImportStatus.pending;
      await startImport(groupId);
    }
  }

  String generateGroupId() {
    // 生成唯一ID的逻辑，可以使用UUID或者其他方式
    final now = DateTime.now();
    return "group_${now.millisecondsSinceEpoch}";
  }

  String generateTaskId() {
    // 生成唯一ID的逻辑，可以使用UUID或者其他方式
    final now = DateTime.now();
    return "task_${now.millisecondsSinceEpoch}";
  }
}
