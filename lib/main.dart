import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/book/book_binding.dart';
import 'package:tele_book/app/screen/book/book_screen.dart';
import 'package:tele_book/app/service/download_service.dart';
import 'package:tele_book/app/service/navigator_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _init();
  runApp(
    GetMaterialApp(
        title: "Application",
        initialBinding: BookBinding(),
        home: BookScreen(),
        getPages: [...AppRoute.pages],
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigatorService.navigatorKey,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xfff3f3f3),
        )),
  );
}

void _init() async {
  Get.put(AppDatabase());
  Get.put(SharedPreferences.getInstance());
  // 初始化后台下载服务
  Get.put(DownloadService());
}
