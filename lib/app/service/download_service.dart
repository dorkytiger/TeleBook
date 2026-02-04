import 'dart:io';
import 'package:background_downloader/background_downloader.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
  }) : status = Rx<TaskStatus>(initialStatus ?? TaskStatus.enqueued),
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
  }) : totalCount = RxInt(total ?? 0),
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

  // 自动重试次数
  final _retryCount = <String, int>{};
  static const int maxRetryCount = 3;

  @override
  void onInit() {
    super.onInit();
    _initDownloader();
  }

  /// 初始化下载器
  Future<void> _initDownloader() async {
    // 请求通知权限（Android 13+ 需要）
    await _requestNotificationPermission();

    // 配置下载器 - 启用后台下载支持
    await FileDownloader().configure(
      globalConfig: [(Config.requestTimeout, const Duration(seconds: 100))],
      androidConfig: [
        (Config.useCacheDir, Config.whenAble),
        (Config.runInForeground, Config.always), // 使用前台服务保持后台下载
      ],
      iOSConfig: [
        (Config.localize, {'Cancel': '取消', 'Pause': '暂停'}),
      ],
    );

    debugPrint('✅ 下载器已配置');

    // 配置通知 - 使用批量下载格式
    FileDownloader().configureNotificationForGroup(
      FileDownloader.defaultGroup,
      // 批量下载进行中
      running: const TaskNotification(
        'TeleBook',
        '正在下载 ({numFinished}/{numTotal}) - {progress}%',
      ),
      // 全部完成
      complete: const TaskNotification('TeleBook - 下载完成', '已完成 {numTotal} 个文件'),
      // 部分失败
      error: const TaskNotification(
        'TeleBook - 下载完成',
        '成功: {numSucceeded} | 失败: {numFailed}',
      ),
      // 已暂停
      paused: const TaskNotification(
        'TeleBook - 已暂停',
        '已下载: {numFinished}/{numTotal}',
      ),
      progressBar: true,
      groupNotificationId: 'download_group', // 使用组通知ID，合并通知
    );

    // 先从数据库恢复组信息
    final groupRows = await appDatabase.downloadGroupTable.select().get();
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

    // 然后恢复任务信息
    final taskRows = await appDatabase.downloadTaskTable.select().get();
    for (final taskRow in taskRows) {
      tasks[taskRow.id] = DownloadTaskInfo(
        taskId: taskRow.id,
        groupId: taskRow.groupId ?? 'default',
        url: taskRow.url,
        filename: taskRow.fileName,
        initialProgress: taskRow.status == TaskStatus.complete.name ? 1.0 : 0.0,
        initialStatus: TaskStatus.values.firstWhere(
          (e) => e.name == taskRow.status,
          orElse: () => TaskStatus.enqueued,
        ),
        initialSavePath: taskRow.filePath,
      );
    }

    // ✅ 重要：恢复后重新计算所有组的统计信息
    // 因为任务状态可能在应用重启前后发生变化
    for (final groupId in groups.keys) {
      _recalculateGroupStats(groupId);
    }

    debugPrint('✅ 已恢复 ${groups.length} 个下载组和 ${tasks.length} 个任务');

    // 监听下载进度和状态更新
    FileDownloader().updates.listen((update) {
      final taskInfo = tasks[update.task.taskId];
      if (taskInfo == null) return;

      // 更新进度
      if (update is TaskProgressUpdate) {
        taskInfo.progress.value = update.progress;
        debugPrint(
          'Task ${update.task.taskId} progress: ${(update.progress * 100).toStringAsFixed(1)}%',
        );

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
          // 清除重试计数
          _retryCount.remove(update.task.taskId);
        } else if (update.status == TaskStatus.failed) {
          // 自动重试失败的任务
          final retries = _retryCount[update.task.taskId] ?? 0;
          if (retries < maxRetryCount) {
            _retryCount[update.task.taskId] = retries + 1;
            debugPrint(
              'Task ${update.task.taskId} failed, auto retry ${retries + 1}/$maxRetryCount',
            );
            // 延迟2秒后重试
            Future.delayed(const Duration(seconds: 2), () {
              retry(update.task.taskId);
            });
          } else {
            debugPrint(
              'Task ${update.task.taskId} failed after $maxRetryCount retries',
            );
            _onDownloadFailed(update.task.taskId);
            _updateGroupStats(taskInfo.groupId);
            _retryCount.remove(update.task.taskId);
          }
        } else if (update.status == TaskStatus.canceled) {
          // 清除重试计数
          _retryCount.remove(update.task.taskId);
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
        metaData: finalGroupId,
        // 使用 metaData 存储 groupId
        displayName: finalFilename,
        // 设置显示名称，用于通知
        group: finalGroupId, // 设置任务组，同组任务会合并通知
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
            filePath: Value(relativePath),
            // 保存相对路径
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

    // 为这个下载组配置专门的通知
    FileDownloader().configureNotificationForGroup(
      finalGroupId,
      // 批量下载进行中
      running: TaskNotification(
        groupInfo.name,
        '正在下载 ({numFinished}/{numTotal}) - {progress}%',
      ),
      // 全部完成
      complete: TaskNotification(
        '${groupInfo.name} - 完成',
        '已下载 {numTotal} 个文件',
      ),
      // 部分失败
      error: TaskNotification(
        '${groupInfo.name} - 完成',
        '成功: {numSucceeded} | 失败: {numFailed}',
      ),
      // 已暂停
      paused: TaskNotification(
        '${groupInfo.name} - 已暂停',
        '已下载: {numFinished}/{numTotal}',
      ),
      progressBar: true,
      groupNotificationId: finalGroupId, // 使用唯一的组ID
    );

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
      'Batch download started: ${taskIds.length}/${urls.length} tasks',
    );
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

  Future<void> resumeAll() async {
    for (final taskId in tasks.keys) {
      await resume(taskId);
    }
  }

  Future<void> deleteAll() async {
    for (final taskId in tasks.keys) {
      await cancel(taskId);
    }
    tasks.clear();
  }

  /// 重试下载
  Future<String?> retry(String taskId) async {
    final taskInfo = tasks[taskId];
    if (taskInfo == null) return null;

    // 确保该组的通知配置存在
    await _ensureGroupNotificationConfigured(taskInfo.groupId);

    // 先取消旧任务
    await FileDownloader().cancelTaskWithId(taskId);

    // 从任务列表中移除
    tasks.remove(taskId);

    // 删除旧的数据库记录
    await appDatabase.downloadTaskTable.deleteWhere(
      (tbl) => tbl.id.equals(taskId),
    );

    // 创建新的下载任务
    return await download(
      url: taskInfo.url,
      filename: taskInfo.filename,
      groupId: taskInfo.groupId,
      updateGroupCount: false, // 不增加组计数，因为是重试
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
    // 确保该组的通知配置存在
    await _ensureGroupNotificationConfigured(groupId);

    final groupTasks = getTasksByGroup(groupId);
    int count = 0;

    for (final taskInfo in groupTasks) {
      // 跳过已完成和正在运行的任务
      if (taskInfo.status.value == TaskStatus.complete ||
          taskInfo.status.value == TaskStatus.running) {
        continue;
      }

      bool success = false;

      // 对于暂停的任务，直接恢复
      if (taskInfo.status.value == TaskStatus.paused) {
        success = await resume(taskInfo.taskId);
        if (success) {
          debugPrint('Resumed paused task: ${taskInfo.taskId}');
        }
      }
      // 对于失败或取消的任务，重新下载
      else if (taskInfo.status.value == TaskStatus.failed ||
          taskInfo.status.value == TaskStatus.canceled ||
          taskInfo.status.value == TaskStatus.notFound) {
        final newTaskId = await retry(taskInfo.taskId);
        success = newTaskId != null;
        if (success) {
          debugPrint('Retried failed/canceled task: ${taskInfo.taskId}');
        }
      }
      // 对于其他状态的任务（如 enqueued），检查是否在队列中
      else {
        // 检查任务是否还在下载器中
        final task = await FileDownloader().taskForId(taskInfo.taskId);
        if (task != null && task is DownloadTask) {
          // 任务存在，尝试恢复
          success = await FileDownloader().resume(task);
          if (success) {
            debugPrint('Resumed enqueued task: ${taskInfo.taskId}');
          }
        } else {
          // 任务不存在，重新创建
          final newTaskId = await download(
            url: taskInfo.url,
            filename: taskInfo.filename,
            groupId: taskInfo.groupId,
            updateGroupCount: false,
          );
          success = newTaskId != null;
          if (success) {
            debugPrint('Re-created missing task: ${taskInfo.taskId}');
          }
        }
      }

      if (success) count++;
    }

    debugPrint('Resumed $count tasks in group $groupId');
    return count;
  }

  /// 取消指定组的所有任务
  Future<int> cancelGroup(String groupId) async {
    final groupTasks = getTasksByGroup(groupId);
    int count = 0;

    for (final taskInfo in groupTasks) {
      // 只取消正在运行或排队的任务
      if (taskInfo.status.value == TaskStatus.running ||
          taskInfo.status.value == TaskStatus.enqueued ||
          taskInfo.status.value == TaskStatus.waitingToRetry) {
        final task = await FileDownloader().taskForId(taskInfo.taskId);
        if (task != null) {
          final success = await FileDownloader().cancelTaskWithId(
            taskInfo.taskId,
          );
          if (success) {
            taskInfo.status.value = TaskStatus.canceled;
            count++;
            debugPrint('Canceled task: ${taskInfo.taskId}');
          }
        }
      }
    }

    // 不移除组信息，保留以便重新下载
    debugPrint('Canceled $count tasks in group $groupId');
    return count;
  }

  /// 删除指定组（包括已下载的文件）
  Future<void> deleteGroup(String groupId) async {
    final groupTasks = getTasksByGroup(groupId);
    await appDatabase.downloadGroupTable.deleteWhere(
      (tbl) => tbl.id.equals(groupId),
    );

    for (final taskInfo in groupTasks) {
      await appDatabase.downloadTaskTable.deleteWhere(
        (tbl) => tbl.id.equals(taskInfo.taskId),
      );
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

  /// 重新下载指定组的所有任务（清空已完成的任务，重新开始）
  Future<int> retryGroup(String groupId) async {
    // 确保该组的通知配置存在
    await _ensureGroupNotificationConfigured(groupId);

    final groupTasks = getTasksByGroup(groupId);
    int count = 0;

    for (final taskInfo in groupTasks) {
      // 跳过正在运行的任务
      if (taskInfo.status.value == TaskStatus.running) {
        continue;
      }

      // 对于所有其他状态的任务（完成、失败、取消等），都重新下载
      final newTaskId = await retry(taskInfo.taskId);
      if (newTaskId != null) {
        count++;
        debugPrint('Re-downloading task: ${taskInfo.filename}');
      }
    }

    debugPrint('Started re-downloading $count tasks in group $groupId');
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

  /// 清理所有已完成的任务（仅保留任务信息，删除文件）
  Future<void> clearCompletedTasks() async {
    final completedTasks = getCompletedTasks();
    for (final taskInfo in completedTasks) {
      final filePath = await getFilePath(taskInfo.taskId);
      if (filePath != null) {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
      }
      // 从任务列表和数据库中移除
      tasks.remove(taskInfo.taskId);
      await appDatabase.downloadTaskTable.deleteWhere(
        (tbl) => tbl.id.equals(taskInfo.taskId),
      );
    }
  }

  /// 下载完成回调
  Future<void> _onDownloadComplete(String taskId) async {
    final taskInfo = tasks[taskId];
    if (taskInfo == null) {
      debugPrint('Task info not found for taskId: $taskId');
      return;
    }

    // 验证文件实际存在
    final fullPath = await getFullPath(taskInfo.savePath.value);
    final file = File(fullPath);
    final exists = await file.exists();

    if (exists) {
      debugPrint('✅ 下载完成: ${taskInfo.filename}');
    } else {
      debugPrint('⚠️ 下载完成但文件不存在: ${taskInfo.savePath.value}');
    }

    // 使用 update 方法更新状态
    await (appDatabase.downloadTaskTable.update()
          ..where((tbl) => tbl.id.equals(taskId)))
        .write(
          DownloadTaskTableCompanion(status: Value(TaskStatus.complete.name)),
        );
  }

  /// 下载失败回调
  void _onDownloadFailed(String taskId) {
    // 使用 update 方法更新状态
    (appDatabase.downloadTaskTable.update()
          ..where((tbl) => tbl.id.equals(taskId)))
        .write(
          DownloadTaskTableCompanion(status: Value(TaskStatus.failed.name)),
        );
    debugPrint('Download failed: $taskId');
  }

  /// 恢复之前的下载任务
  Future<void> _resumePreviousTasks() async {
    try {
      // 从数据库加载所有未完成的任务
      final dbTasks = await appDatabase.downloadTaskTable.select().get();

      // 用于跟踪哪些组需要配置通知
      final Set<String> groupsToConfig = {};

      for (final dbTask in dbTasks) {
        // 只恢复未完成的任务
        if (dbTask.status == TaskStatus.complete.name) {
          continue;
        }

        final groupId = dbTask.groupId ?? 'default';
        groupsToConfig.add(groupId);

        // 检查任务是否还在下载器中
        final existingTask = await FileDownloader().taskForId(dbTask.id);

        if (existingTask != null && existingTask is DownloadTask) {
          // 任务存在，恢复任务信息
          final taskInfo = DownloadTaskInfo(
            taskId: dbTask.id,
            groupId: groupId,
            url: dbTask.url,
            filename: dbTask.fileName,
            initialSavePath: dbTask.filePath,
            initialStatus: TaskStatus.values.firstWhere(
              (e) => e.name == dbTask.status,
              orElse: () => TaskStatus.enqueued,
            ),
          );
          tasks[dbTask.id] = taskInfo;

          // 如果任务是暂停状态，尝试恢复
          if (dbTask.status == TaskStatus.paused.name) {
            await FileDownloader().resume(existingTask);
            debugPrint('Resumed paused task: ${dbTask.id}');
          }
        } else {
          // 任务不存在，可能需要重新创建
          // 对于失败或取消的任务，不自动重试
          if (dbTask.status == TaskStatus.failed.name ||
              dbTask.status == TaskStatus.canceled.name) {
            // 保留任务信息但不重新下载
            final taskInfo = DownloadTaskInfo(
              taskId: dbTask.id,
              groupId: groupId,
              url: dbTask.url,
              filename: dbTask.fileName,
              initialSavePath: dbTask.filePath,
              initialStatus: TaskStatus.values.firstWhere(
                (e) => e.name == dbTask.status,
                orElse: () => TaskStatus.failed,
              ),
            );
            tasks[dbTask.id] = taskInfo;
          }
        }
      }

      // 为所有涉及的组配置通知
      for (final groupId in groupsToConfig) {
        await _ensureGroupNotificationConfigured(groupId);
      }

      debugPrint('Resumed ${tasks.length} tasks from database');
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

  /// 重新计算组的统计信息（用于应用重启后）
  void _recalculateGroupStats(String groupId) {
    final groupInfo = groups[groupId];
    if (groupInfo == null) return;

    final groupTasks = getTasksByGroup(groupId);

    // 重新计算总数（以实际任务数为准）
    final actualTotal = groupTasks.length;
    if (actualTotal != groupInfo.totalCount.value) {
      debugPrint(
        '⚠️ Group $groupId total count mismatch: '
        'expected ${groupInfo.totalCount.value}, actual $actualTotal',
      );
      groupInfo.totalCount.value = actualTotal;
    }

    int completed = 0;
    int failed = 0;
    int running = 0;
    double totalProgress = 0.0;

    for (final task in groupTasks) {
      // 累加进度
      totalProgress += task.progress.value;

      // 统计状态
      if (task.status.value == TaskStatus.complete) {
        completed++;
      } else if (task.status.value == TaskStatus.failed) {
        failed++;
      } else if (task.status.value == TaskStatus.running) {
        running++;
      }
    }

    // 更新统计信息
    groupInfo.completedCount.value = completed;
    groupInfo.failedCount.value = failed;

    // 计算整体进度
    final progress = groupTasks.isNotEmpty
        ? totalProgress / groupTasks.length
        : 0.0;
    groupInfo.groupProgress.value = progress;

    debugPrint(
      '📊 Group $groupId stats: '
      'total=$actualTotal, completed=$completed, failed=$failed, '
      'progress=${(progress * 100).toStringAsFixed(1)}%',
    );

    // 同步到数据库
    (appDatabase.downloadGroupTable.update()
          ..where((tbl) => tbl.id.equals(groupId)))
        .write(
          DownloadGroupTableCompanion(
            totalCount: Value(actualTotal),
            completedCount: Value(completed),
            failedCount: Value(failed),
            runningCount: Value(running),
            groupProgress: Value(progress),
            updatedAt: Value(DateTime.now()),
            completedAt: Value(
              completed == actualTotal && actualTotal > 0
                  ? DateTime.now()
                  : null,
            ),
          ),
        );
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

  /// 请求通知权限
  Future<void> _requestNotificationPermission() async {
    try {
      // Android 13+ (API 33+) 需要通知权限
      if (Platform.isAndroid) {
        final status = await Permission.notification.status;

        if (status.isDenied) {
          debugPrint('📢 请求通知权限...');
          final result = await Permission.notification.request();

          if (result.isGranted) {
            debugPrint('✅ 通知权限已授予');
          } else if (result.isDenied) {
            debugPrint('❌ 通知权限被拒绝');
            debugPrint('💡 请在系统设置中手动授予通知权限以查看下载进度');
          } else if (result.isPermanentlyDenied) {
            debugPrint('❌ 通知权限被永久拒绝');
            debugPrint('💡 请前往：系统设置 → 应用 → TeleBook → 通知 → 允许通知');

            // 可选：引导用户去设置
            // await openAppSettings();
          }
        } else if (status.isGranted) {
          debugPrint('✅ 通知权限已授予');
        } else if (status.isPermanentlyDenied) {
          debugPrint('❌ 通知权限被永久拒绝，请在系统设置中授予');
        }
      }
    } catch (e) {
      debugPrint('⚠️ 检查通知权限时出错: $e');
    }
  }

  /// 检查通知权限状态
  Future<bool> checkNotificationPermission() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.notification.status;
        return status.isGranted;
      }
      return true; // iOS 不需要此权限
    } catch (e) {
      debugPrint('检查通知权限失败: $e');
      return false;
    }
  }

  /// 打开应用设置（用于授予权限）
  Future<void> openNotificationSettings() async {
    try {
      await openAppSettings();
      debugPrint('已打开应用设置页面');
    } catch (e) {
      debugPrint('打开设置失败: $e');
    }
  }

  /// 确保下载组的通知配置存在
  Future<void> _ensureGroupNotificationConfigured(String groupId) async {
    final groupInfo = groups[groupId];
    if (groupInfo == null) {
      debugPrint(
        '⚠️ Group $groupId not found, using default notification config',
      );
      return;
    }

    // 为该组配置通知
    FileDownloader().configureNotificationForGroup(
      groupId,
      running: TaskNotification(
        groupInfo.name,
        '正在下载 ({numFinished}/{numTotal}) - {progress}%',
      ),
      complete: TaskNotification(
        '${groupInfo.name} - 完成',
        '已下载 {numTotal} 个文件',
      ),
      error: TaskNotification(
        '${groupInfo.name} - 完成',
        '成功: {numSucceeded} | 失败: {numFailed}',
      ),
      paused: TaskNotification(
        '${groupInfo.name} - 已暂停',
        '已下载: {numFinished}/{numTotal}',
      ),
      progressBar: true,
      groupNotificationId: groupId,
    );

    debugPrint('✅ Configured notification for group: $groupId');
  }
}
