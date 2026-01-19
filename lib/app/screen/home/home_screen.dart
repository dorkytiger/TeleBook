import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/book/book_screen.dart';
import 'package:tele_book/app/screen/manage/manage_screen.dart';
import 'package:tele_book/app/screen/setting/setting_screen.dart';
import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.selectedIndex.value == 0) {
          return BookScreen();
        }
        if (controller.selectedIndex.value == 1) {
          return ManageScreen();
        }
        if (controller.selectedIndex.value == 2) {
          return SettingScreen();
        }
        return SizedBox.shrink();
      }),
      bottomNavigationBar: TDBottomTabBar(
        TDBottomTabBarBasicType.iconText,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            onTap: () {
              controller.selectedIndex.value = 0;
            },
            tabText: '书籍',
            unselectedIcon: Icon(Icons.book),
            selectedIcon: Icon(
              Icons.book_outlined,
              color: TDTheme.of(context).brandNormalColor,
            ),
          ),
          TDBottomTabBarTabConfig(
            onTap: () {
              controller.selectedIndex.value = 1;
            },
            tabText: '管理',
            unselectedIcon: Icon(Icons.grid_on),
            selectedIcon: Icon(
              Icons.grid_on_outlined,
              color: TDTheme.of(context).brandNormalColor,
            ),
          ),
          TDBottomTabBarTabConfig(
            onTap: () {
              controller.selectedIndex.value = 2;
            },
            tabText: '设置',
            unselectedIcon: Icon(Icons.settings),
            selectedIcon: Icon(
              Icons.settings_outlined,
              color: TDTheme.of(context).brandNormalColor,
            ),
          ),
        ],
      ),
    );
  }
}
