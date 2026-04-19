import 'package:flutter/material.dart';
import 'package:tele_book/app/store/download_store.dart';
import 'package:tele_book/app/util/file_util.dart';

class DownloadTaskController extends ChangeNotifier {
  final String groupId;
  final DownloadStore downloadStore;

  DownloadTaskController({required this.groupId, required this.downloadStore}) {
    downloadStore.addListener(_onStoreChanged);
  }

  void _onStoreChanged() => notifyListeners();

  List<DownloadTaskInfo> get tasks => downloadStore.getTasksByGroup(groupId);

  String? getFilePath(String savePath) =>
      FileUtil.getFullPath(savePath);

  Future<void> resume(String taskId) => downloadStore.resume(taskId);
  Future<void> pause(String taskId) => downloadStore.pause(taskId);
  Future<void> cancel(String taskId) => downloadStore.cancel(taskId);
  Future<void> retry(String taskId) => downloadStore.retry(taskId);

  @override
  void dispose() {
    downloadStore.removeListener(_onStoreChanged);
    super.dispose();
  }
}
