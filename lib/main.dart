import 'package:dk_util/config/dk_config.dart';
import 'package:dk_util/dk_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tele_book/app/theme/app_theme.dart';
import 'package:tele_book/app/util/file_util.dart';

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
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 480, name: MOBILE),
          const Breakpoint(start: 481, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1200, name: DESKTOP),
          const Breakpoint(start: 1201, end: double.infinity, name: '4K'),
        ],
      ),
    ),
  );
}
