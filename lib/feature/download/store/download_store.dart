import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tele_book/feature/download/model/vo/download_vo.dart';
import 'package:tele_book/feature/download/service/download_service.dart';

class DownloadStore extends ChangeNotifier {
  final DownloadService _downloadService;
  StreamSubscription<List<DownloadTaskVO>>? _tasksSubscription;

  DownloadStore(this._downloadService) {
    _tasksSubscription = _downloadService.watchDownloadTasks().listen((event) {
      _tasks = event;
      notifyListeners();
    });
  }

  List<DownloadTaskVO> _tasks = [];

  List<DownloadTaskVO> get tasks => _tasks;

  Future<void> retryDownload(String taskId) async {
    await _downloadService.retryTask(taskId);
  }

  @override
  void dispose() {
    _tasksSubscription?.cancel();
    super.dispose();
  }
}
