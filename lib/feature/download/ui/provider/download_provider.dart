import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/download/datasource/runtime/download_runtime_datasource.dart';
import 'package:tele_book/feature/download/model/vo/download_vo.dart';
import 'package:tele_book/feature/download/repository/download_repository.dart';
import 'package:tele_book/feature/download/service/download_service.dart';

/// 内存数据源 —— 全局单例，生命周期同 ProviderScope
final downloadRuntimeDatasourceProvider =
    Provider<DownloadRuntimeDatasource>((ref) {
  final ds = DownloadRuntimeDatasource();
  ref.onDispose(ds.dispose);
  return ds;
});

final downloadRepositoryProvider = Provider<DownloadRepository>((ref) {
  return DownloadRepository(ref.watch(downloadRuntimeDatasourceProvider));
});

final downloadServiceProvider = Provider<DownloadService>((ref) {
  return DownloadService(
    ref.watch(downloadRepositoryProvider),
    ref.watch(bookRepositoryProvider),
  );
});

/// 监听下载任务列表（响应式 Stream）
final downloadTasksProvider = StreamProvider<List<DownloadTaskVO>>((ref) {
  return ref.watch(downloadServiceProvider).watchDownloadTasks();
});

