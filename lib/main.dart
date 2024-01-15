import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              color: Colors.blue,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20)),
          primaryColor: Colors.white,
          dialogTheme: const DialogTheme(
              backgroundColor: Colors.white, surfaceTintColor: Colors.white),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  iconColor: MaterialStateProperty.resolveWith((states) {
            // 根据不同的状态返回不同的颜色
            if (states.contains(MaterialState.pressed)) {
              // 按钮被按下时的颜色
              return Colors.white;
            } else {
              // 默认状态下的颜色
              return Colors.white;
            }
          }), backgroundColor: MaterialStateProperty.resolveWith((states) {
            // 根据不同的状态返回不同的颜色
            if (states.contains(MaterialState.pressed)) {
              // 按钮被按下时的颜色
              return Colors.blueAccent;
            } else {
              // 默认状态下的颜色
              return Colors.blue;
            }
          }))),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          floatingActionButtonTheme:
              const FloatingActionButtonThemeData(backgroundColor: Colors.blue),
          bottomNavigationBarTheme:
              const BottomNavigationBarThemeData(backgroundColor: Colors.white),
          progressIndicatorTheme:
              const ProgressIndicatorThemeData(color: Colors.blue)),
    ),
  );
}
