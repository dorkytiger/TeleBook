import 'package:flutter/material.dart';
import 'package:tele_book/app/store/download_store.dart';

/// DownloadController - UI 控制器（ViewModel）
///
/// 职责（单向数据流）：
/// - 监听 Store 的变化并转换为 UI 需要的数据
/// - 管理 UI 特定的状态（加载提示、错误消息等）
/// - 将用户意图转发给 Store
/// - 暴露 UI 需要的数据，避免 UI 直接访问 Store
///
/// 数据流向：Controller → Store → Service → DAO
class DownloadController extends ChangeNotifier {
  final DownloadStore _downloadStore;

  DownloadController({required DownloadStore downloadStore})
      : _downloadStore = downloadStore {
    _downloadStore.addListener(_onStoreChanged);
  }

  void _onStoreChanged() => notifyListeners();

  // ══════════════════════════════════════════════════════════════════════════
  // ViewModel - 暴露 UI 需要的数据
  // ══════════════════════════════════════════════════════════════════════════

  /// 获取所有下载组列表
  List<MapEntry<String, DownloadGroupInfo>> get groups {
    return _downloadStore.groups.entries.toList();
  }

  /// 下载组是否为空
  bool get isEmpty => _downloadStore.groups.isEmpty;

  /// 获取指定下载组信息
  DownloadGroupInfo? getGroup(String groupId) {
    return _downloadStore.groups[groupId];
  }

  /// 获取指定下载组的任务列表
  List<DownloadTaskInfo> getTasksByGroup(String groupId) {
    return _downloadStore.getTasksByGroup(groupId);
  }

  /// 获取任务的完整路径
  Future<String?> getTaskFullPath(String taskId) async {
    return await _downloadStore.getFilePath(taskId);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 用户操作 - 转发给 Store
  // ══════════════════════════════════════════════════════════════════════════


  /// 取消下载组
  Future<void> cancelGroup(String groupId) async {
    await _downloadStore.cancelGroup(groupId);
  }

  /// 恢复下载组
  Future<void> resumeGroup(String groupId) async {
    await _downloadStore.resumeGroup(groupId);
  }

  /// 暂停下载组
  Future<void> pauseGroup(String groupId) async {
    await _downloadStore.pauseGroup(groupId);
  }

  /// 重试下载组
  Future<void> retryGroup(String groupId) async {
    await _downloadStore.retryGroup(groupId);
  }

  /// 删除下载组
  Future<void> deleteGroup(String groupId) async {
    await _downloadStore.deleteGroup(groupId);
  }


  @override
  void dispose() {
    _downloadStore.removeListener(_onStoreChanged);
    super.dispose();
  }
}
