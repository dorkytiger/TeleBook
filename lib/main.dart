import 'dart:io';

import 'package:dk_util/config/dk_config.dart';
import 'package:dk_util/dk_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/book/book_binding.dart';
import 'package:tele_book/app/screen/book/book_screen.dart';
import 'package:tele_book/app/screen/home/home_bind.dart';
import 'package:tele_book/app/screen/home/home_screen.dart';
import 'package:tele_book/app/service/download_service.dart';
import 'package:tele_book/app/service/export_service.dart';
import 'package:tele_book/app/service/navigator_service.dart';
import 'package:tele_book/app/theme/app_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _init();

  runApp(
    GetMaterialApp(
      title: "TeleBook",
      initialBinding: HomeBind(),
      home: HomeScreen(),
      getPages: [...AppRoute.pages],
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigatorService.navigatorKey,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
    ),
  );
}

Future<void> _init() async {
  await DKLog.initFileLog();
  DkConfig.setShowStateLog(true);
  Get.put(AppDatabase());
  await Get.putAsync<SharedPreferences>(() => SharedPreferences.getInstance());
  // 初始化后台下载服务
  Get.put(DownloadService());
  Get.put<ExportService>(ExportService());

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
