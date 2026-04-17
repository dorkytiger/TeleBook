import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:dk_util/dk_util.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/util/file_util.dart';

/// 进度事件
typedef DownloadProgressEvent = ({String taskId, double progress});

/// 状态事件
typedef DownloadStatusEvent = ({String taskId, TaskStatus status});

/// 纯下载操作服务，不持有任何业务状态。
/// 通过 Stream 广播进度和状态变化，支持多个订阅者。
class DownloadService {
  final AppDatabase _db;

  // ── Stream（broadcast：支持多订阅者） ────────────────────────────────────
  final _progressCtrl = StreamController<DownloadProgressEvent>.broadcast();
  final _statusCtrl = StreamController<DownloadStatusEvent>.broadcast();

  /// 订阅下载进度（可多处 listen）
  Stream<DownloadProgressEvent> get onProgress => _progressCtrl.stream;

  /// 订阅状态变化（可多处 listen）
  Stream<DownloadStatusEvent> get onStatusChanged => _statusCtrl.stream;

  DownloadService(this._db) {
    init();
  }

  void dispose() {
    _progressCtrl.close();
    _statusCtrl.close();
  }

  // ── 初始化 ───────────────────────────────────────────────────────────────

  /// 初始化下载器（应在 app 启动时调用一次）
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

    // 默认组通知
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

    // 监听 FileDownloader 事件，转发到 Stream
    FileDownloader().updates.listen((update) {
      if (update is TaskProgressUpdate) {
        debugPrint(
          'Task ${update.task.taskId} progress: '
          '${(update.progress * 100).toStringAsFixed(1)}%',
        );
        _progressCtrl.add((
          taskId: update.task.taskId,
          progress: update.progress,
        ));
      }
      if (update is TaskStatusUpdate) {
        debugPrint('Task ${update.task.taskId} status: ${update.status}');
        _statusCtrl.add((taskId: update.task.taskId, status: update.status));
      }
    });
  }

  // ── 下载操作 ─────────────────────────────────────────────────────────────

  /// 将一个任务加入下载队列，返回 taskId；失败返回 null。
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
      } else {
        debugPrint('Failed to enqueue download task');
        return null;
      }
    } catch (e) {
      debugPrint('Error enqueuing download: $e');
      return null;
    }
  }

  /// 暂停
  Future<bool> pause(String taskId) async {
    final task = await FileDownloader().taskForId(taskId);
    if (task == null || task is! DownloadTask) return false;
    return FileDownloader().pause(task);
  }

  /// 恢复
  Future<bool> resume(String taskId) async {
    final task = await FileDownloader().taskForId(taskId);
    if (task == null || task is! DownloadTask) return false;
    return FileDownloader().resume(task);
  }

  /// 取消单个任务
  Future<bool> cancel(String taskId) async {
    return FileDownloader().cancelTaskWithId(taskId);
  }

  /// 批量取消
  Future<void> cancelAll(List<String> taskIds) async {
    await FileDownloader().cancelTasksWithIds(taskIds);
  }

  /// 查询下载器中是否还有该任务
  Future<Task?> taskForId(String taskId) {
    return FileDownloader().taskForId(taskId);
  }

  // ── 路径工具 ─────────────────────────────────────────────────────────────

  /// 相对路径 → 完整绝对路径
  Future<String> getFullPath(String relativePath) async {
    return FileUtil.getFullPath(relativePath);
  }

  // ── 通知配置 ─────────────────────────────────────────────────────────────

  /// 为下载组配置通知（批量下载 / 恢复时调用）
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
    debugPrint('✅ Configured notification for group: $groupId');
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
        if (result.isGranted) {
          debugPrint('✅ 通知权限已授予');
        } else if (result.isPermanentlyDenied) {
          debugPrint('❌ 通知权限被永久拒绝，请在系统设置中授予');
        } else {
          debugPrint('❌ 通知权限被拒绝');
        }
      } else if (status.isGranted) {
        debugPrint('✅ 通知权限已授予');
      }
    } catch (e) {
      debugPrint('⚠️ 检查通知权限时出错: $e');
    }
  }

  // ── 业务逻辑：保存下载组为书籍 ────────────────────────────────────────────

  /// 验证下载组的文件并返回有效的路径列表
  ///
  /// 检查所有下载任务的文件是否真实存在于文件系统中
  /// 返回：(有效路径列表, 缺失文件数量)
  Future<(List<String>, int)> validateDownloadedFiles({
    required List<String> relativePaths,
  }) async {
    final (validPaths, notFoundCount) = await FileUtil.validateFiles(
      relativePaths,
    );

    if (notFoundCount > 0) {
      DKLog.w('⚠️ 有 $notFoundCount 个下载文件不存在');
    }

    DKLog.d(
      '📊 验证结果: 有效文件 ${validPaths.length}/${relativePaths.length}, 缺失 $notFoundCount',
    );
    return (validPaths, notFoundCount);
  }

  Future<void> saveDownloadAsBook({
    required String bookName,
    required List<String> downloadedPaths,
  }) async {
    final (validPaths, notFoundCount) = await validateDownloadedFiles(
      relativePaths: downloadedPaths,
    );

    // 2. 检查是否有有效文件
    if (validPaths.isEmpty) {
      throw Exception('没有找到任何有效的下载文件，可能文件已被删除');
    }

    if (notFoundCount > 0) {
      DKLog.w('⚠️ 有 $notFoundCount 个文件缺失，但仍将保存书籍');
    }

    // 3. 直接调用 DAO 保存书籍（不调用 BookService，避免 Service 间依赖）
    DKLog.d('💾 保存书籍: $bookName (${validPaths.length} 个文件)');
    await _db.bookDao.insertBook(
      BookTableCompanion.insert(name: bookName, localPaths: validPaths),
    );

    DKLog.s('✅ 书籍保存成功: $bookName');
  }
}
