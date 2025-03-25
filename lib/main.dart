import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/nav/nav_binding.dart';
import 'package:tele_book/app/nav/nav_view.dart';
import 'package:tele_book/app/service/tb_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  _init();

  runApp(
    GetMaterialApp(
        title: "Application",
        initialBinding: NavBinding(),
        home:  const NavView(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xfff3f3f3),
        )),
  );
}

void _init() async {
  Get.put(AppDatabase());
  Get.put(SharedPreferences.getInstance());
}
