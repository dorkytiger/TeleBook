import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/nav/nav_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AppDatabase());
  Get.put(SharedPreferences.getInstance());

  runApp(
    GetMaterialApp(
        title: "Application",
        home: const NavView(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xfff3f3f3),
        )),
  );
}
