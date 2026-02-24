import 'dart:io';
import 'package:background_downloader/background_downloader.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/service/import_service.dart';

/// 下载任务状态
class DownloadTaskInfo {
  final String taskId;
  final String groupId; // 批次 ID，用于管理一批下载任务
  final String url;
  final String filename;
  final int order; // 下载顺序，用于批量下载时排序
  final Rx<TaskStatus> status;
  final RxDouble progress;
  final RxString savePath;

  DownloadTaskInfo({
    required this.taskId,
    required this.groupId,
    required this.url,
    required this.order,
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
            _updateGroupStats(taskInfo.groupId);
            _retryCount.remove(update.task.taskId);
          }
        } else if (update.status == TaskStatus.canceled) {
          // 清除重试计数
          _retryCount.remove(update.task.taskId);
        }
      }
    });
  }

  /// 开始下载任务
  Future<String?> download({
    required String url,
    String? filename,
    String? subDirectory,
    String? groupId,
    bool updateGroupCount = true, // 是否更新组计数，批量下载时为 false
    int? order, // 指定顺序，重试时传入原有 order 以保持顺序不变
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
      // 如果外部传入了 order（如重试时），保持原有顺序；否则用当前任务数
      final taskOrder = order ?? tasks.length;
      final taskInfo = DownloadTaskInfo(
        taskId: task.taskId,
        groupId: finalGroupId,
        url: url,
        order: taskOrder,
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
          } else {
            // 增加总数
            groups[finalGroupId]!.totalCount.value++;
          }
        }
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
    return result;
  }

  /// 取消所有下载
  Future<void> cancelAll() async {
    await FileDownloader().cancelTasksWithIds(tasks.keys.toList());
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

    // 保留原有 order，以保持任务顺序不变
    final originalOrder = taskInfo.order;

    // 先取消旧任务
    await FileDownloader().cancelTaskWithId(taskId);

    // 从任务列表中移除
    tasks.remove(taskId);

    // 创建新的下载任务，传入原有 order
    return await download(
      url: taskInfo.url,
      filename: taskInfo.filename,
      groupId: taskInfo.groupId,
      updateGroupCount: false,
      // 不增加组计数，因为是重试
      order: originalOrder, // 保持原有顺序
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
    final list = tasks.values.where((task) => task.groupId == groupId).toList();
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
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

    for (final taskInfo in groupTasks) {
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

    // 更新组整体进度
    _updateGroupProgress(groupId);

    // 所有任务都完成时，自动保存为书籍
    final allDone =
        groupTasks.isNotEmpty &&
        groupTasks.every(
          (t) =>
              t.status.value == TaskStatus.complete ||
              t.status.value == TaskStatus.failed ||
              t.status.value == TaskStatus.canceled,
        );

    if (allDone && completed == groupTasks.length) {
      _saveGroupAsBook(groupId, groupInfo, groupTasks);
    }
  }

  /// 下载组全部完成后，通过 ImportService 保存为书籍
  Future<void> _saveGroupAsBook(
    String groupId,
    DownloadGroupInfo groupInfo,
    List<DownloadTaskInfo> groupTasks,
  ) async {
    // 按 order 排序，保证书页顺序正确
    final sorted = [...groupTasks]..sort((a, b) => a.order.compareTo(b.order));
    final localPaths = sorted
        .where(
          (t) =>
              t.status.value == TaskStatus.complete &&
              t.savePath.value.isNotEmpty,
        )
        .map((t) => t.savePath.value)
        .toList();

    if (localPaths.isEmpty) {
      debugPrint('⚠️ 下载组 ${groupInfo.name} 没有成功的任务，跳过保存');
      return;
    }

    try {
      final importService = Get.find<ImportService>();
      await importService.saveBookFromPaths(
        name: groupInfo.name,
        localPaths: localPaths,
      );
      debugPrint('✅ 下载组 ${groupInfo.name} 已自动保存为书籍');
    } catch (e) {
      debugPrint('❌ 保存书籍失败: $e');
    }
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
