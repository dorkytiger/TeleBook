import 'dart:io';

import 'package:dk_util/config/dk_config.dart';
import 'package:dk_util/dk_util.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/service/book_service.dart';
import 'package:tele_book/app/service/download_service.dart';
import 'package:tele_book/app/store/book_store.dart';
import 'package:tele_book/app/store/download_store.dart';
import 'package:tele_book/app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _init();

  runApp(appProviders);
}

/// 全局 providers，在 runApp 中使用
late Widget appProviders;

Future<void> _init() async {
  await DKLog.initFileLog();
  DkConfig.setShowStateLog(true);

  final db = AppDatabase();
  final bookService = BookService(db);
  final downloadService = DownloadService();
  final downloadStore = DownloadStore(downloadService);
  await downloadStore.init();

  appProviders = MultiProvider(
    providers: [
      Provider<AppDatabase>.value(value: db),
      Provider<BookService>.value(value: bookService),
      Provider<DownloadService>.value(value: downloadService),
      ChangeNotifierProvider<BookStore>(
        create: (_) => BookStore(bookService)..refresh(),
      ),
      ChangeNotifierProvider<DownloadStore>.value(value: downloadStore),
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
