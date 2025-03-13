import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wo_nas/app/db/app_database.dart';
import 'package:wo_nas/app/view/book/book_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AppDatabase());

  runApp(
    GetMaterialApp(
        title: "Application",
        home: const BookView(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xfff3f3f3),
        )),
  );
}
