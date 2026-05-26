import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/download/datasource/runtime/download_runtime_datasource.dart';
import 'package:tele_book/feature/download/model/vo/download_vo.dart';
import 'package:tele_book/feature/download/repository/download_repository.dart';
import 'package:tele_book/feature/download/service/download_service.dart';


/// 监听下载任务列表（响应式 Stream）
final downloadTasksProvider = StreamProvider<List<DownloadTaskVO>>((ref) {
  return ref.watch(downloadServiceProvider).watchDownloadTasks();
});

