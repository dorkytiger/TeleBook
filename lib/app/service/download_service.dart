import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tele_book/app/util/file_util.dart';

/// 纯下载操作服务，不持有任何业务状态。
/// FileDownloader.updates 直接暴露给 Store 订阅。
class DownloadService {
  DownloadService() {
    init();
  }

  /// 直接暴露 FileDownloader 的更新流，Store 自行订阅处理
  Stream<TaskUpdate> get updates => FileDownloader().updates;

  // ── 初始化 ───────────────────────────────────────────────────────────────

  Future<void> init() async {
    await _requestNotificationPermission();

    await FileDownloader().configure(
      globalConfig: [(Config.requestTimeout, const Duration(seconds: 100))],
      androidConfig: [
        (Config.useCacheDir, Config.whenAble),
        (Config.runInForeground, Config.always),
      ],
      iOSConfig: [
        (Config.localize, {'Cancel': '取消', 'Pause': '暂停'}),
      ],
    );
    debugPrint('✅ 下载器已配置');

    FileDownloader().configureNotificationForGroup(
      FileDownloader.defaultGroup,
      running: const TaskNotification(
        'TeleBook',
        '正在下载 ({numFinished}/{numTotal}) - {progress}%',
      ),
      complete: const TaskNotification('TeleBook - 下载完成', '已完成 {numTotal} 个文件'),
      error: const TaskNotification(
        'TeleBook - 下载完成',
        '成功: {numSucceeded} | 失败: {numFailed}',
      ),
      paused: const TaskNotification(
        'TeleBook - 已暂停',
        '已下载: {numFinished}/{numTotal}',
      ),
      progressBar: true,
      groupNotificationId: 'download_group',
    );
  }

  // ── 下载操作 ─────────────────────────────────────────────────────────────

  Future<String?> enqueue({
    required String url,
    required String filename,
    required String groupId,
  }) async {
    try {
      final task = DownloadTask(
        url: url,
        filename: filename,
        directory: groupId,
        baseDirectory: BaseDirectory.applicationDocuments,
        updates: Updates.statusAndProgress,
        allowPause: true,
        metaData: groupId,
        displayName: filename,
        group: groupId,
      );
      final result = await FileDownloader().enqueue(task);
      if (result) {
        debugPrint('Download task enqueued: ${task.taskId}');
        return task.taskId;
      }
      debugPrint('Failed to enqueue download task');
      return null;
    } catch (e) {
      debugPrint('Error enqueuing download: $e');
      return null;
    }
  }

  Future<bool> pause(String taskId) async {
    final task = await FileDownloader().taskForId(taskId);
    if (task == null || task is! DownloadTask) return false;
    return FileDownloader().pause(task);
  }

  Future<bool> resume(String taskId) async {
    final task = await FileDownloader().taskForId(taskId);
    if (task == null || task is! DownloadTask) return false;
    return FileDownloader().resume(task);
  }

  Future<bool> cancel(String taskId) async {
    return FileDownloader().cancelTaskWithId(taskId);
  }

  Future<void> cancelAll(List<String> taskIds) async {
    await FileDownloader().cancelTasksWithIds(taskIds);
  }

  Future<Task?> taskForId(String taskId) {
    return FileDownloader().taskForId(taskId);
  }

  // ── 路径工具 ─────────────────────────────────────────────────────────────

  Future<String> getFullPath(String relativePath) async {
    return FileUtil.getFullPath(relativePath);
  }

  // ── 通知配置 ─────────────────────────────────────────────────────────────

  void configureGroupNotification(String groupId, String groupName) {
    FileDownloader().configureNotificationForGroup(
      groupId,
      running: TaskNotification(
        groupName,
        '正在下载 ({numFinished}/{numTotal}) - {progress}%',
      ),
      complete: TaskNotification('$groupName - 完成', '已下载 {numTotal} 个文件'),
      error: TaskNotification(
        '$groupName - 完成',
        '成功: {numSucceeded} | 失败: {numFailed}',
      ),
      paused: TaskNotification(
        '$groupName - 已暂停',
        '已下载: {numFinished}/{numTotal}',
      ),
      progressBar: true,
      groupNotificationId: groupId,
    );
  }

  // ── 权限 ─────────────────────────────────────────────────────────────────

  Future<bool> checkNotificationPermission() async {
    try {
      if (Platform.isAndroid) {
        return (await Permission.notification.status).isGranted;
      }
      return true;
    } catch (e) {
      debugPrint('检查通知权限失败: $e');
      return false;
    }
  }

  Future<void> openNotificationSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      debugPrint('打开设置失败: $e');
    }
  }

  Future<void> _requestNotificationPermission() async {
    try {
      if (!Platform.isAndroid) return;
      final status = await Permission.notification.status;
      if (status.isDenied) {
        debugPrint('📢 请求通知权限...');
        final result = await Permission.notification.request();
        debugPrint(result.isGranted ? '✅ 通知权限已授予' : '❌ 通知权限被拒绝');
      }
    } catch (e) {
      debugPrint('⚠️ 检查通知权限时出错: $e');
    }
  }
}
