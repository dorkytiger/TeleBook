import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wo_nas/app/db/app_database.dart';
import 'package:wo_nas/app/view/home/views/home_view.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AppDatabase());

  runApp(
    GetMaterialApp(
      title: "Application",
      home:const HomeView(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColorLight: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blue),
          appBarTheme: const AppBarTheme(
              color: Colors.blue,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20)),
          primaryColor: Colors.white,
          dialogTheme: const DialogTheme(
              backgroundColor: Colors.white, surfaceTintColor: Colors.white),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  iconColor: WidgetStateProperty.resolveWith((states) {
            // 根据不同的状态返回不同的颜色
            if (states.contains(WidgetState.pressed)) {
              // 按钮被按下时的颜色
              return Colors.white;
            } else {
              // 默认状态下的颜色
              return Colors.white;
            }
          }), backgroundColor: WidgetStateProperty.resolveWith((states) {
            // 根据不同的状态返回不同的颜色
            if (states.contains(WidgetState.pressed)) {
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
