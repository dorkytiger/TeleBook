import 'dart:io';

import 'package:dk_util/config/dk_config.dart';
import 'package:dk_util/dk_util.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/service/book_service.dart';
import 'package:tele_book/app/service/collection_servcie.dart';
import 'package:tele_book/app/service/download_service.dart';
import 'package:tele_book/app/service/export_service.dart';
import 'package:tele_book/app/service/import_service.dart';
import 'package:tele_book/app/service/mark_service.dart';
import 'package:tele_book/app/store/book_store.dart';
import 'package:tele_book/app/store/collection_store.dart';
import 'package:tele_book/app/store/download_store.dart';
import 'package:tele_book/app/store/export_store.dart';
import 'package:tele_book/app/store/import_store.dart';
import 'package:tele_book/app/store/mark_store.dart';
import 'package:tele_book/app/util/file_util.dart';
import 'package:tele_book/app/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _init();

  runApp(appProviders);
}

/// 全局 providers，在 runApp 中使用
late Widget appProviders;

Future<void> _init() async {
  await FileUtil.init();
  await DKLog.initFileLog();
  DkConfig.setShowStateLog(true);

  final db = AppDatabase();
  final bookService = BookService(db);
  final markService = MarkService(db);
  final collectionService = CollectionService(db);
  final downloadService = DownloadService();
  final downloadStore = DownloadStore(downloadService, bookService);

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // 导出服务与状态管理
  final exportService = ExportService(db);
  final exportStore = ExportStore(exportService);

  // 导入服务与状态管理
  final importService = ImportService();
  final importStore = ImportStore(importService, bookService);

  // 标签和收藏夹状态管理
  final markStore = MarkStore(markService);
  final collectionStore = CollectionStore(collectionService);

  // 书籍状态管理（提前创建，BookStore 内部监听 BookService 自动响应新增）
  final bookStore = BookStore(bookService);


  appProviders = MultiProvider(
    providers: [
      // Services
      Provider<AppDatabase>.value(value: db),
      Provider<BookService>.value(value: bookService),
      Provider<MarkService>.value(value: markService),
      Provider<CollectionService>.value(value: collectionService),
      Provider<DownloadService>.value(value: downloadService),
      Provider<ExportService>.value(value: exportService),
      Provider<ImportService>.value(value: importService),
      Provider<SharedPreferences>.value(value: sharedPreferences),

      // Stores
      ChangeNotifierProvider<BookStore>.value(value: bookStore),
      ChangeNotifierProvider<MarkStore>.value(value: markStore),
      ChangeNotifierProvider<CollectionStore>.value(value: collectionStore),
      ChangeNotifierProvider<DownloadStore>.value(value: downloadStore),
      ChangeNotifierProvider<ExportStore>.value(value: exportStore),
      ChangeNotifierProvider<ImportStore>.value(value: importStore),
    ],
    child: MaterialApp.router(
      title: 'TeleBook',
      routerConfig: AppRoute.router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
    ),
  );

  // 清理临时目录
  await _cleanupTempDirectory();
}

/// 清理临时目录
Future<void> _cleanupTempDirectory() async {
  try {
    final tempDir = await getTemporaryDirectory();

    // 清理批量导入的临时文件
    final batchImportDir = Directory('${tempDir.path}/batch_import');
    if (await batchImportDir.exists()) {
      await batchImportDir.delete(recursive: true);
      debugPrint('已清理批量导入临时目录: ${batchImportDir.path}');
    }

    // 清理其他临时解压文件（根据时间戳命名的文件夹）
    if (await tempDir.exists()) {
      final entries = tempDir.listSync();
      for (final entry in entries) {
        if (entry is Directory) {
          // 删除以数字命名的临时文件夹（时间戳格式）
          final dirName = entry.path.split(Platform.pathSeparator).last;
          if (RegExp(r'^\d+$').hasMatch(dirName)) {
            try {
              await entry.delete(recursive: true);
              debugPrint('已清理临时目录: ${entry.path}');
            } catch (e) {
              debugPrint('清理临时目录失败: ${entry.path}, 错误: $e');
            }
          }
        }
      }
    }

    debugPrint('临时目录清理完成');
  } catch (e) {
    debugPrint('清理临时目录时出错: $e');
    // 清理失败不影响应用启动
  }
}
