import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:tele_book/app/service/book_service.dart';
import 'package:tele_book/app/service/download_service.dart';
import 'package:tele_book/app/util/file_util.dart';

// ── 数据模型 ──────────────────────────────────────────────────────────────────

/// 下载任务信息（由 DownloadStore 持有和更新）
class DownloadTaskInfo {
  final String taskId;
  final String groupId;
  final String url;
  final String filename;
  final int order; // 下载顺序，批量时保证书页顺序

  // 可变状态
  TaskStatus status;
  double progress;
  String savePath; // 相对路径：groupId/filename

  DownloadTaskInfo({
    required this.taskId,
    required this.groupId,
    required this.url,
    required this.order,
    required this.filename,
    TaskStatus? initialStatus,
    double? initialProgress,
    String? initialSavePath,
  }) : status = initialStatus ?? TaskStatus.enqueued,
       progress = initialProgress ?? 0.0,
       savePath = initialSavePath ?? '';
}

/// 下载组信息（由 DownloadStore 持有和更新）
class DownloadGroupInfo {
  final String groupId;
  final String name;
  final DateTime createTime;

  // 可变状态
  int totalCount;
  int completedCount;
  int failedCount;
  double groupProgress;

  DownloadGroupInfo({
    required this.groupId,
    required this.name,
    int? total,
    int? completed,
    int? failed,
  }) : totalCount = total ?? 0,
       completedCount = completed ?? 0,
       failedCount = failed ?? 0,
       groupProgress = 0.0,
       createTime = DateTime.now();

  double get progressPercent =>
      totalCount > 0 ? completedCount / totalCount : 0.0;
}

// ── Store ─────────────────────────────────────────────────────────────────────

class DownloadStore extends ChangeNotifier {
  final DownloadService _service;
  final BookService _bookService;

  // ── 状态 ──────────────────────────────────────────────────────────────────
  final tasks = <String, DownloadTaskInfo>{};
  final groups = <String, DownloadGroupInfo>{};

  final _retryCount = <String, int>{};
  static const int maxRetryCount = 3;

  StreamSubscription? _updatesSub;

  void Function(String groupId, String name, List<String> sortedPaths)?
  onGroupCompleted;

  // ── 构造 ──────────────────────────────────────────────────────────────────

  DownloadStore(this._service, this._bookService) {
    // 直接订阅 FileDownloader 更新流
    _updatesSub = _service.updates.listen((update) {
      if (update is TaskProgressUpdate) {
        _handleProgress(update.task.taskId, update.progress);
      } else if (update is TaskStatusUpdate) {
        _handleStatusChanged(update.task.taskId, update.status);
      }
    });
  }

  @override
  void dispose() {
    _updatesSub?.cancel();
    super.dispose();
  }

  // ── 服务回调处理 ──────────────────────────────────────────────────────────

  void _handleProgress(String taskId, double progress) {
    final task = tasks[taskId];
    if (task == null) return;

    task.progress = progress;
    _updateGroupProgress(task.groupId);
    notifyListeners();
  }

  void _handleStatusChanged(String taskId, TaskStatus status) {
    final task = tasks[taskId];
    if (task == null) return;

    task.status = status;

    if (status == TaskStatus.complete) {
      _retryCount.remove(taskId);
      _verifyFile(taskId);
      _updateGroupStats(task.groupId);
    } else if (status == TaskStatus.failed) {
      final retries = _retryCount[taskId] ?? 0;
      if (retries < maxRetryCount) {
        _retryCount[taskId] = retries + 1;
        debugPrint(
          'Task $taskId failed, auto retry ${retries + 1}/$maxRetryCount',
        );
        Future.delayed(const Duration(seconds: 2), () => retry(taskId));
      } else {
        debugPrint('Task $taskId failed after $maxRetryCount retries');
        _retryCount.remove(taskId);
        _updateGroupStats(task.groupId);
      }
    } else if (status == TaskStatus.canceled) {
      _retryCount.remove(taskId);
    }

    notifyListeners();
  }

  // ── 下载操作 ──────────────────────────────────────────────────────────────

  /// 单个下载；[updateGroupCount] 批量时设为 false（组计数已在外部设置）
  Future<String?> download({
    required String url,
    String? filename,
    String? groupId,
    bool updateGroupCount = true,
    int? order,
  }) async {
    final finalFilename = filename ?? _filenameFromUrl(url);
    final finalGroupId = groupId ?? 'default';
    final relativePath = '$finalGroupId/$finalFilename';
    final taskOrder = order ?? tasks.length;

    final taskId = await _service.enqueue(
      url: url,
      filename: finalFilename,
      groupId: finalGroupId,
    );

    if (taskId == null) return null;

    tasks[taskId] = DownloadTaskInfo(
      taskId: taskId,
      groupId: finalGroupId,
      url: url,
      order: taskOrder,
      filename: finalFilename,
      initialSavePath: relativePath,
    );

    if (updateGroupCount) {
      if (!groups.containsKey(finalGroupId)) {
        groups[finalGroupId] = DownloadGroupInfo(
          groupId: finalGroupId,
          name: finalGroupId == 'default' ? '默认组' : finalGroupId,
          total: 1,
        );
      } else {
        groups[finalGroupId]!.totalCount++;
      }
    }

    notifyListeners();
    return taskId;
  }

  /// 批量下载
  Future<DownloadGroupInfo> downloadBatch({
    required List<String> urls,
    String? groupId,
    String? groupName,
  }) async {
    final finalGroupId =
        groupId ?? 'group_${DateTime.now().millisecondsSinceEpoch}';
    final finalName =
        groupName ?? '批量下载 ${DateTime.now().toString().substring(0, 19)}';

    final groupInfo = DownloadGroupInfo(
      groupId: finalGroupId,
      name: finalName,
      total: urls.length,
    );
    groups[finalGroupId] = groupInfo;
    _service.configureGroupNotification(finalGroupId, finalName);
    notifyListeners();

    for (final url in urls) {
      await download(url: url, groupId: finalGroupId, updateGroupCount: false);
    }

    debugPrint('Batch download started: ${urls.length} tasks');
    return groupInfo;
  }

  /// 暂停
  Future<bool> pause(String taskId) => _service.pause(taskId);

  /// 恢复
  Future<bool> resume(String taskId) => _service.resume(taskId);

  /// 取消单个任务并从列表移除
  Future<bool> cancel(String taskId) async {
    if (!tasks.containsKey(taskId)) return false;
    final result = await _service.cancel(taskId);
    tasks.remove(taskId);
    notifyListeners();
    return result;
  }

  /// 取消全部
  Future<void> cancelAll() async {
    await _service.cancelAll(tasks.keys.toList());
    tasks.clear();
    notifyListeners();
  }

  Future<void> resumeAll() async {
    for (final taskId in tasks.keys.toList()) {
      await resume(taskId);
    }
  }

  Future<void> deleteAll() async {
    await cancelAll();
  }

  /// 重试（保持原有 order）
  Future<String?> retry(String taskId) async {
    final taskInfo = tasks[taskId];
    if (taskInfo == null) return null;

    _service.configureGroupNotification(
      taskInfo.groupId,
      groups[taskInfo.groupId]?.name ?? taskInfo.groupId,
    );

    final originalOrder = taskInfo.order;
    await _service.cancel(taskId);
    tasks.remove(taskId);

    return download(
      url: taskInfo.url,
      filename: taskInfo.filename,
      groupId: taskInfo.groupId,
      updateGroupCount: false,
      order: originalOrder,
    );
  }

  // ── 组操作 ────────────────────────────────────────────────────────────────

  /// 暂停组内所有运行中的任务
  Future<int> pauseGroup(String groupId) async {
    int count = 0;
    for (final t in _tasksByGroup(groupId)) {
      if (t.status == TaskStatus.running) {
        if (await pause(t.taskId)) count++;
      }
    }
    return count;
  }

  /// 恢复组内未完成的任务
  Future<int> resumeGroup(String groupId) async {
    final groupInfo = groups[groupId];
    if (groupInfo != null) {
      _service.configureGroupNotification(groupId, groupInfo.name);
    }

    int count = 0;
    for (final t in _tasksByGroup(groupId)) {
      if (t.status == TaskStatus.complete || t.status == TaskStatus.running) {
        continue;
      }

      bool success = false;
      if (t.status == TaskStatus.paused) {
        success = await resume(t.taskId);
      } else if (t.status == TaskStatus.failed ||
          t.status == TaskStatus.canceled ||
          t.status == TaskStatus.notFound) {
        success = await retry(t.taskId) != null;
      } else {
        // enqueued 等状态：检查下载器中是否还有
        final existing = await _service.taskForId(t.taskId);
        if (existing != null) {
          success = await resume(t.taskId);
        } else {
          success =
              await download(
                url: t.url,
                filename: t.filename,
                groupId: t.groupId,
                updateGroupCount: false,
              ) !=
              null;
        }
      }
      if (success) count++;
    }

    debugPrint('Resumed $count tasks in group $groupId');
    return count;
  }

  /// 取消组内活跃任务
  Future<int> cancelGroup(String groupId) async {
    int count = 0;
    for (final t in _tasksByGroup(groupId)) {
      if (t.status == TaskStatus.running ||
          t.status == TaskStatus.enqueued ||
          t.status == TaskStatus.waitingToRetry) {
        if (await _service.cancel(t.taskId)) {
          t.status = TaskStatus.canceled;
          count++;
        }
      }
    }
    notifyListeners();
    debugPrint('Canceled $count tasks in group $groupId');
    return count;
  }

  /// 删除组（取消任务 + 删除已下载文件 + 移除组信息）
  Future<void> deleteGroup(String groupId) async {
    for (final t in _tasksByGroup(groupId)) {
      if (t.status == TaskStatus.complete && t.savePath.isNotEmpty) {
        final fullPath = await _service.getFullPath(t.savePath);
        final file = File(fullPath);
        if (await file.exists()) await file.delete();
      }
      await _service.cancel(t.taskId);
      tasks.remove(t.taskId);
    }
    groups.remove(groupId);
    notifyListeners();
  }

  /// 重新下载组内所有任务
  Future<int> retryGroup(String groupId) async {
    final groupInfo = groups[groupId];
    if (groupInfo != null) {
      _service.configureGroupNotification(groupId, groupInfo.name);
    }

    int count = 0;
    for (final t in _tasksByGroup(groupId)) {
      if (t.status == TaskStatus.running) continue;
      if (await retry(t.taskId) != null) count++;
    }
    debugPrint('Started re-downloading $count tasks in group $groupId');
    return count;
  }

  // ── 查询 ──────────────────────────────────────────────────────────────────

  DownloadTaskInfo? getTaskInfo(String taskId) => tasks[taskId];

  List<DownloadTaskInfo> getAllTasks() => tasks.values.toList();

  List<DownloadTaskInfo> getTasksByGroup(String groupId) =>
      _tasksByGroup(groupId);

  List<DownloadGroupInfo> getAllGroups() => groups.values.toList();

  DownloadGroupInfo? getGroupInfo(String groupId) => groups[groupId];

  List<DownloadTaskInfo> getRunningTasks() =>
      tasks.values.where((t) => t.status == TaskStatus.running).toList();

  List<DownloadTaskInfo> getCompletedTasks() =>
      tasks.values.where((t) => t.status == TaskStatus.complete).toList();

  /// 获取任务文件的完整路径
  Future<String?> getFilePath(String taskId) async {
    final t = tasks[taskId];
    if (t == null || t.savePath.isEmpty) return null;
    return _service.getFullPath(t.savePath);
  }

  Future<bool> fileExists(String taskId) async {
    final path = await getFilePath(taskId);
    if (path == null) return false;
    return File(path).exists();
  }

  /// 清理已完成任务（删除文件并从列表移除）
  Future<void> clearCompletedTasks() async {
    for (final t in getCompletedTasks()) {
      if (t.savePath.isNotEmpty) {
        final path = await _service.getFullPath(t.savePath);
        final file = File(path);
        if (await file.exists()) await file.delete();
      }
      tasks.remove(t.taskId);
    }
    notifyListeners();
  }

  // ── 权限（透传） ──────────────────────────────────────────────────────────

  Future<bool> checkNotificationPermission() =>
      _service.checkNotificationPermission();

  Future<void> openNotificationSettings() =>
      _service.openNotificationSettings();


  Future<void> saveToBook(String groupId) async {
    final group = groups[groupId];
    if (group == null) throw Exception("未找到下载组 $groupId");
    if (group.completedCount != group.totalCount) {
      throw Exception("下载未完成（${group.completedCount}/${group.totalCount}），无法保存到书架");
    }

    final savePaths = _tasksByGroup(groupId)
        .where((t) => t.status == TaskStatus.complete && t.savePath.isNotEmpty)
        .map((t) => t.savePath)
        .toList();
    if (savePaths.isEmpty) throw Exception('没有找到任何已完成的下载文件');

    // 验证文件是否真实存在
    final (validPaths, notFoundCount) = await FileUtil.validateFiles(savePaths);
    if (validPaths.isEmpty) throw Exception('没有找到任何有效的下载文件，可能文件已被删除');
    if (notFoundCount > 0) debugPrint('⚠️ 有 $notFoundCount 个文件缺失，但仍将保存书籍');

    // 通过 BookService 保存（会触发 bookInsertedStream → BookStore 自动刷新）
    await _bookService.insertWithPaths(
      name: group.name,
      localPaths: validPaths,
    );

    debugPrint('✅ Store: 下载组 ${group.name} 已保存为书籍');
    notifyListeners();
  }

  // ── 私有辅助 ──────────────────────────────────────────────────────────────

  List<DownloadTaskInfo> _tasksByGroup(String groupId) {
    final list = tasks.values.where((t) => t.groupId == groupId).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  void _updateGroupProgress(String groupId) {
    final groupInfo = groups[groupId];
    if (groupInfo == null) return;
    final groupTasks = _tasksByGroup(groupId);
    if (groupTasks.isEmpty) return;
    final total = groupTasks.fold(0.0, (sum, t) => sum + t.progress);
    groupInfo.groupProgress = total / groupTasks.length;
  }

  void _updateGroupStats(String groupId) {
    final groupInfo = groups[groupId];
    if (groupInfo == null) return;

    final groupTasks = _tasksByGroup(groupId);
    int completed = 0, failed = 0;
    for (final t in groupTasks) {
      if (t.status == TaskStatus.complete) completed++;
      if (t.status == TaskStatus.failed) failed++;
    }
    groupInfo.completedCount = completed;
    groupInfo.failedCount = failed;
    _updateGroupProgress(groupId);

    // 判断组是否全部结束（完成 / 失败 / 取消）
    final allDone =
        groupTasks.isNotEmpty &&
        groupTasks.every(
          (t) =>
              t.status == TaskStatus.complete ||
              t.status == TaskStatus.failed ||
              t.status == TaskStatus.canceled,
        );

    if (allDone && completed == groupTasks.length) {
      _onGroupAllCompleted(groupId, groupInfo, groupTasks);
    }
  }

  void _onGroupAllCompleted(
    String groupId,
    DownloadGroupInfo groupInfo,
    List<DownloadTaskInfo> groupTasks,
  ) {
    final sorted = [...groupTasks]..sort((a, b) => a.order.compareTo(b.order));
    final paths = sorted
        .where((t) => t.status == TaskStatus.complete && t.savePath.isNotEmpty)
        .map((t) => t.savePath)
        .toList();

    if (paths.isEmpty) {
      debugPrint('⚠️ 下载组 ${groupInfo.name} 没有成功的任务，跳过');
      return;
    }

    debugPrint('✅ 下载组 ${groupInfo.name} 全部完成');
    onGroupCompleted?.call(groupId, groupInfo.name, paths);
  }

  Future<void> _verifyFile(String taskId) async {
    final t = tasks[taskId];
    if (t == null) return;
    final fullPath = await _service.getFullPath(t.savePath);
    final exists = await File(fullPath).exists();
    if (exists) {
      debugPrint('✅ 下载完成: ${t.filename}');
    } else {
      debugPrint('⚠️ 下载完成但文件不存在: ${t.savePath}');
    }
  }

  String _filenameFromUrl(String url) {
    try {
      final segments = Uri.parse(url).pathSegments;
      if (segments.isNotEmpty) return segments.last;
    } catch (_) {}
    return 'download_${DateTime.now().millisecondsSinceEpoch}';
  }
}
