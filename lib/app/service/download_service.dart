import 'dart:io';
import 'package:background_downloader/background_downloader.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';

/// 下载任务状态
class DownloadTaskInfo {
  final String taskId;
  final String groupId; // 批次 ID，用于管理一批下载任务
  final String url;
  final String filename;
  final Rx<TaskStatus> status;
  final RxDouble progress;
  final RxString savePath;

  DownloadTaskInfo({
    required this.taskId,
    required this.groupId,
    required this.url,
    required this.filename,
    TaskStatus? initialStatus,
    double? initialProgress,
    String? initialSavePath,
  })  : status = Rx<TaskStatus>(initialStatus ?? TaskStatus.enqueued),
        progress = RxDouble(initialProgress ?? 0.0),
        savePath = RxString(initialSavePath ?? '');
}

/// 下载组信息
class DownloadGroupInfo {
  final String groupId;
  final String name;
  final RxInt totalCount;
  final RxInt completedCount;
  final RxInt failedCount;
  final RxDouble groupProgress;
  final Rx<DateTime> createTime;

  DownloadGroupInfo({
    required this.groupId,
    required this.name,
    int? total,
    int? completed,
    int? failed,
  })  : totalCount = RxInt(total ?? 0),
        completedCount = RxInt(completed ?? 0),
        failedCount = RxInt(failed ?? 0),
        groupProgress = RxDouble(0.0),
        createTime = Rx<DateTime>(DateTime.now());

  double get progressPercent =>
      totalCount.value > 0 ? completedCount.value / totalCount.value : 0.0;
}

class DownloadService extends GetxService {
  static DownloadService get instance => Get.find<DownloadService>();

  final appDatabase = Get.find<AppDatabase>();

  // 所有下载任务
  final tasks = <String, DownloadTaskInfo>{}.obs;

  // 所有下载组
  final groups = <String, DownloadGroupInfo>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initDownloader();
  }

  /// 初始化下载器
  Future<void> _initDownloader() async {
    // 配置下载器
    FileDownloader().configureNotification(
      running: const TaskNotification(
        '{displayName}',
        'Downloading: {progress}%',
      ),
      complete: const TaskNotification(
        '{displayName}',
        'Download complete',
      ),
      error: const TaskNotification(
        '{displayName}',
        'Download failed',
      ),
      paused: const TaskNotification(
        '{displayName}',
        'Download paused',
      ),
    );

    appDatabase.downloadGroupTable.select().get().then((groupRows) {
      for (final groupRow in groupRows) {
        groups[groupRow.id] = DownloadGroupInfo(
          groupId: groupRow.id,
          name: groupRow.name,
          total: groupRow.totalCount,
          completed: groupRow.completedCount,
          failed: groupRow.failedCount,
        );
        // 恢复组进度
        groups[groupRow.id]!.groupProgress.value = groupRow.groupProgress;
      }
    });

    appDatabase.downloadTaskTable.select().get().then((taskRows) {
      for (final taskRow in taskRows) {
        tasks[taskRow.id] = DownloadTaskInfo(
          taskId: taskRow.id,
          groupId: taskRow.groupId ?? 'default',
          url: taskRow.url,
          filename: taskRow.fileName,
          initialStatus: TaskStatus.values.firstWhere(
              (e) => e.name == taskRow.status,
              orElse: () => TaskStatus.enqueued),
          initialSavePath: taskRow.filePath,
        );
      }
    });

    // 监听下载进度和状态更新
    FileDownloader().updates.listen((update) {
      final taskInfo = tasks[update.task.taskId];
      if (taskInfo == null) return;

      // 更新进度
      if (update is TaskProgressUpdate) {
        taskInfo.progress.value = update.progress;
        debugPrint(
            'Task ${update.task.taskId} progress: ${(update.progress * 100).toStringAsFixed(1)}%');

        // 更新组进度
        _updateGroupProgress(taskInfo.groupId);
      }

      // 更新状态
      if (update is TaskStatusUpdate) {
        taskInfo.status.value = update.status;
        debugPrint('Task ${update.task.taskId} status: ${update.status}');
        // 下载完成后更新保存路径
        if (update.status == TaskStatus.complete) {
          _onDownloadComplete(update.task.taskId);
          _updateGroupStats(taskInfo.groupId);
        } else if (update.status == TaskStatus.failed) {
          _onDownloadFailed(update.task.taskId);
          _updateGroupStats(taskInfo.groupId);
        }
      }
    });

    // 恢复之前的下载任务（应用重启后）
    await _resumePreviousTasks();
  }

  /// 开始下载任务
  Future<String?> download({
    required String url,
    String? filename,
    String? subDirectory,
    String? groupId,
    bool updateGroupCount = true, // 是否更新组计数，批量下载时为 false
  }) async {
    try {
      // 如果没有指定文件名，从 URL 提取
      final finalFilename = filename ?? _getFilenameFromUrl(url);

      // 如果没有指定 groupId，使用默认组
      final finalGroupId = groupId ?? 'default';

      // 使用 groupId 作为子目录
      final directory = finalGroupId;

      // 创建下载任务
      final task = DownloadTask(
        url: url,
        filename: finalFilename,
        directory: directory,
        baseDirectory: BaseDirectory.applicationDocuments,
        updates: Updates.statusAndProgress,
        allowPause: true,
        metaData: finalGroupId, // 使用 metaData 存储 groupId
      );

      // 创建任务信息，savePath 存储相对路径
      final relativePath = '$finalGroupId/$finalFilename';
      final taskInfo = DownloadTaskInfo(
        taskId: task.taskId,
        groupId: finalGroupId,
        url: url,
        filename: finalFilename,
        initialSavePath: relativePath,
      );

      tasks[task.taskId] = taskInfo;

      // 加入下载队列
      final result = await FileDownloader().enqueue(task);

      if (result) {
        debugPrint('Download task enqueued: ${task.taskId}');

        // 只在 updateGroupCount 为 true 时更新组计数
        if (updateGroupCount) {
          // 确保组存在
          if (!groups.containsKey(finalGroupId)) {
            groups[finalGroupId] = DownloadGroupInfo(
              groupId: finalGroupId,
              name: finalGroupId == 'default' ? '默认组' : finalGroupId,
              total: 1,
            );

            // 创建新组时保存到数据库
            appDatabase.downloadGroupTable.insertOnConflictUpdate(
              DownloadGroupTableCompanion(
                id: Value(finalGroupId),
                name: Value(groups[finalGroupId]!.name),
                totalCount: Value(1),
                completedCount: Value(0),
                failedCount: Value(0),
                runningCount: Value(0),
                groupProgress: Value(0.0),
                createdAt: Value(DateTime.now()),
                updatedAt: Value(DateTime.now()),
              ),
            );
          } else {
            // 增加总数
            groups[finalGroupId]!.totalCount.value++;

            // 更新组计数
            (appDatabase.downloadGroupTable.update()
                  ..where((tbl) => tbl.id.equals(finalGroupId)))
                .write(
              DownloadGroupTableCompanion(
                totalCount: Value(groups[finalGroupId]!.totalCount.value),
                updatedAt: Value(DateTime.now()),
              ),
            );
          }
        }

        appDatabase.downloadTaskTable.insertOnConflictUpdate(
          DownloadTaskTableCompanion(
            id: Value(task.taskId),
            groupId: Value(finalGroupId),
            url: Value(url),
            fileName: Value(finalFilename),
            filePath: Value(relativePath), // 保存相对路径
            status: Value(TaskStatus.enqueued.name),
            createdAt: Value(DateTime.now()),
          ),
        );
        return task.taskId;
      } else {
        debugPrint('Failed to enqueue download task');
        tasks.remove(task.taskId);
        return null;
      }
    } catch (e) {
      debugPrint('Error starting download: $e');
      return null;
    }
  }

  /// 批量下载
  Future<DownloadGroupInfo> downloadBatch({
    required List<String> urls,
    String? subDirectory,
    String? groupId,
    String? groupName,
  }) async {
    // 生成批次 ID
    final finalGroupId =
        groupId ?? 'group_${DateTime.now().millisecondsSinceEpoch}';

    // 创建下载组
    final groupInfo = DownloadGroupInfo(
      groupId: finalGroupId,
      name: groupName ?? '批量下载 ${DateTime.now().toString().substring(0, 19)}',
      total: urls.length,
    );
    groups[finalGroupId] = groupInfo;
    await appDatabase.downloadGroupTable.insertOnConflictUpdate(
      DownloadGroupTableCompanion(
        id: Value(finalGroupId),
        name: Value(groupInfo.name),
        totalCount: Value(urls.length),
        completedCount: Value(0),
        failedCount: Value(0),
        runningCount: Value(0),
        groupProgress: Value(0.0),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );

    final taskIds = <String>[];

    for (final url in urls) {
      final taskId = await download(
        url: url,
        subDirectory: subDirectory,
        groupId: finalGroupId,
        updateGroupCount: false, // 批量下载时不更新计数，因为已经在创建组时设置了
      );
      if (taskId != null) {
        taskIds.add(taskId);
      }
    }

    debugPrint(
        'Batch download started: ${taskIds.length}/${urls.length} tasks');
    return groupInfo;
  }

  /// 暂停下载
  Future<bool> pause(String taskId) async {
    final taskInfo = tasks[taskId];
    if (taskInfo == null) return false;

    final task = await FileDownloader().taskForId(taskId);
    if (task == null || task is! DownloadTask) return false;

    return await FileDownloader().pause(task);
  }

  /// 恢复下载
  Future<bool> resume(String taskId) async {
    final taskInfo = tasks[taskId];
    if (taskInfo == null) return false;

    final task = await FileDownloader().taskForId(taskId);
    if (task == null || task is! DownloadTask) return false;

    return await FileDownloader().resume(task);
  }

  /// 取消下载
  Future<bool> cancel(String taskId) async {
    final taskInfo = tasks[taskId];
    if (taskInfo == null) return false;

    final task = await FileDownloader().taskForId(taskId);
    if (task == null) return false;

    final result = await FileDownloader().cancelTaskWithId(taskId);
    tasks.remove(taskId);
    appDatabase.downloadTaskTable.deleteWhere((tbl) => tbl.id.equals(taskId));
    return result;
  }

  /// 取消所有下载
  Future<void> cancelAll() async {
    await FileDownloader().cancelTasksWithIds(tasks.keys.toList());
    for (final taskId in tasks.keys) {
      appDatabase.downloadTaskTable.deleteWhere((tbl) => tbl.id.equals(taskId));
    }
    tasks.clear();
  }

  /// 重试下载
  Future<String?> retry(String taskId) async {
    final taskInfo = tasks[taskId];
    if (taskInfo == null) return null;
    return await download(
      url: taskInfo.url,
      filename: taskInfo.filename,
      groupId: taskInfo.groupId,
    );
  }

  /// 获取任务信息
  DownloadTaskInfo? getTaskInfo(String taskId) {
    return tasks[taskId];
  }

  /// 获取所有任务
  List<DownloadTaskInfo> getAllTasks() {
    return tasks.values.toList();
  }

  /// 获取指定组的所有任务
  List<DownloadTaskInfo> getTasksByGroup(String groupId) {
    return tasks.values.where((task) => task.groupId == groupId).toList();
  }

  /// 获取所有下载组
  List<DownloadGroupInfo> getAllGroups() {
    return groups.values.toList();
  }

  /// 获取组信息
  DownloadGroupInfo? getGroupInfo(String groupId) {
    return groups[groupId];
  }

  /// 暂停指定组的所有任务
  Future<int> pauseGroup(String groupId) async {
    final groupTasks = getTasksByGroup(groupId);
    int count = 0;

    for (final taskInfo in groupTasks) {
      if (taskInfo.status.value == TaskStatus.running) {
        final success = await pause(taskInfo.taskId);
        if (success) count++;
      }
    }

    return count;
  }

  /// 恢复指定组的所有任务
  Future<int> resumeGroup(String groupId) async {
    final groupTasks = getTasksByGroup(groupId);
    int count = 0;

    for (final taskInfo in groupTasks) {
      if (taskInfo.status.value == TaskStatus.paused) {
        final success = await resume(taskInfo.taskId);
        if (success) count++;
      }
    }

    return count;
  }

  /// 取消指定组的所有任务
  Future<int> cancelGroup(String groupId) async {
    final groupTasks = getTasksByGroup(groupId);
    int count = 0;

    for (final taskInfo in groupTasks) {
      final success = await cancel(taskInfo.taskId);
      if (success) count++;
    }

    // 移除组信息
    groups.remove(groupId);

    return count;
  }

  /// 删除指定组（包括已下载的文件）
  Future<void> deleteGroup(String groupId) async {
    final groupTasks = getTasksByGroup(groupId);
   await appDatabase.downloadGroupTable
        .deleteWhere((tbl) => tbl.id.equals(groupId));

    for (final taskInfo in groupTasks) {
      await appDatabase.downloadTaskTable
          .deleteWhere((tbl) => tbl.id.equals(taskInfo.taskId));
      // 如果下载完成，删除文件
      if (taskInfo.status.value == TaskStatus.complete) {
        final filePath = await getFilePath(taskInfo.taskId);
        if (filePath != null) {
          final file = File(filePath);
          if (await file.exists()) {
            await file.delete();
          }
        }
      }

      // 取消任务
      await cancel(taskInfo.taskId);
    }

    // 移除组信息
    groups.remove(groupId);
  }

  /// 重试指定组的所有失败任务
  Future<int> retryGroup(String groupId) async {
    final groupTasks = getTasksByGroup(groupId);
    int count = 0;
    for (final taskInfo in groupTasks) {
      if (taskInfo.status.value == TaskStatus.failed) {
        final newTaskId = await retry(taskInfo.taskId);
        if (newTaskId != null) {
          count++;
        }
      }
    }
    return count;
  }

  /// 获取正在下载的任务
  List<DownloadTaskInfo> getRunningTasks() {
    return tasks.values
        .where((task) => task.status.value == TaskStatus.running)
        .toList();
  }

  /// 获取已完成的任务
  List<DownloadTaskInfo> getCompletedTasks() {
    return tasks.values
        .where((task) => task.status.value == TaskStatus.complete)
        .toList();
  }

  /// 下载完成回调
  Future<void> _onDownloadComplete(String taskId) async {
    final taskInfo = tasks[taskId];
    if (taskInfo == null) {
      debugPrint('Task info not found for taskId: $taskId');
      return;
    }

    // 相对路径已经在创建任务时设置，无需更新
    debugPrint('Download complete: ${taskInfo.savePath.value}');

    // 使用 update 方法更新状态
    await (appDatabase.downloadTaskTable.update()
          ..where((tbl) => tbl.id.equals(taskId)))
        .write(
      DownloadTaskTableCompanion(
        status: Value(TaskStatus.complete.name),
      ),
    );
  }

  /// 下载失败回调
  void _onDownloadFailed(String taskId) {
    // 使用 update 方法更新状态
    (appDatabase.downloadTaskTable.update()
          ..where((tbl) => tbl.id.equals(taskId)))
        .write(
      DownloadTaskTableCompanion(
        status: Value(TaskStatus.failed.name),
      ),
    );
    debugPrint('Download failed: $taskId');
  }

  /// 恢复之前的下载任务
  Future<void> _resumePreviousTasks() async {
    try {
      final allTasks = await FileDownloader().allTasks();

      for (final task in allTasks) {
        if (task is DownloadTask) {
          // 从 metaData 恢复 groupId，如果没有则使用默认值
          final groupId = task.metaData.isNotEmpty ? task.metaData : 'default';

          final taskInfo = DownloadTaskInfo(
            taskId: task.taskId,
            groupId: groupId,
            url: task.url,
            filename: task.filename,
          );
          tasks[task.taskId] = taskInfo;

          // 获取任务状态
          final status = await FileDownloader().taskForId(task.taskId);
          if (status != null) {
            debugPrint('Resumed task: ${task.taskId} in group: $groupId');
          }
        }
      }
    } catch (e) {
      debugPrint('Error resuming tasks: $e');
    }
  }


  /// 从 URL 提取文件名
  String _getFilenameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      if (segments.isNotEmpty) {
        return segments.last;
      }
    } catch (e) {
      debugPrint('Error parsing URL: $e');
    }
    return 'download_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// 获取下载文件的完整路径（通过相对路径）
  Future<String?> getFilePath(String taskId) async {
    final taskInfo = tasks[taskId];
    if (taskInfo == null || taskInfo.savePath.value.isEmpty) return null;

    // 获取应用文档目录
    final appDocDir = await getApplicationDocumentsDirectory();

    // 拼接完整路径：appDocDir + groupId + filename
    return '${appDocDir.path}/${taskInfo.savePath.value}';
  }

  /// 通过相对路径获取完整路径
  Future<String> getFullPath(String relativePath) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return '${appDocDir.path}/$relativePath';
  }

  /// 检查文件是否存在
  Future<bool> fileExists(String taskId) async {
    final filePath = await getFilePath(taskId);
    if (filePath == null) return false;
    return File(filePath).exists();
  }

  /// 更新组统计信息
  void _updateGroupStats(String groupId) {
    final groupInfo = groups[groupId];
    if (groupInfo == null) return;

    final groupTasks = getTasksByGroup(groupId);

    int completed = 0;
    int failed = 0;
    int running = 0;

    for (final task in groupTasks) {
      if (task.status.value == TaskStatus.complete) {
        completed++;
      } else if (task.status.value == TaskStatus.failed) {
        failed++;
      } else if (task.status.value == TaskStatus.running) {
        running++;
      }
    }

    groupInfo.completedCount.value = completed;
    groupInfo.failedCount.value = failed;

    // 同步到数据库 - 使用 update 方法
    (appDatabase.downloadGroupTable.update()
          ..where((tbl) => tbl.id.equals(groupId)))
        .write(
      DownloadGroupTableCompanion(
        totalCount: Value(groupInfo.totalCount.value),
        completedCount: Value(completed),
        failedCount: Value(failed),
        runningCount: Value(running),
        updatedAt: Value(DateTime.now()),
        completedAt: Value(
          completed == groupInfo.totalCount.value ? DateTime.now() : null,
        ),
      ),
    );

    // 更新组整体进度
    _updateGroupProgress(groupId);
  }

  /// 更新组整体进度
  void _updateGroupProgress(String groupId) {
    final groupInfo = groups[groupId];
    if (groupInfo == null) return;

    final groupTasks = getTasksByGroup(groupId);
    if (groupTasks.isEmpty) return;

    double totalProgress = 0.0;
    for (final task in groupTasks) {
      totalProgress += task.progress.value;
    }

    final progress = totalProgress / groupTasks.length;
    groupInfo.groupProgress.value = progress;

    // 同步进度到数据库 - 使用 update 方法
    (appDatabase.downloadGroupTable.update()
          ..where((tbl) => tbl.id.equals(groupId)))
        .write(
      DownloadGroupTableCompanion(
        groupProgress: Value(progress),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
