import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/nav/nav_controller.dart';
import 'package:tele_book/app/view/book/book_view.dart';
import 'package:tele_book/app/view/download/download_view.dart';
import 'package:tele_book/app/view/setting/setting_view.dart';

class NavView extends GetView<NavController> {
  const NavView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controller.selectedIndex) {
          case 0:
            return BookView();
          case 1:
            return DownloadView();
          case 2:
            return SettingView();
          default:
            return BookView();
        }
      }),
      bottomNavigationBar: Obx(() => TDBottomTabBar(
              currentIndex: controller.selectedIndex,
              TDBottomTabBarBasicType.iconText,
              navigationTabs: [
                TDBottomTabBarTabConfig(
                    selectedIcon: Icon(
                      TDIcons.book_filled,
                      color: TDTheme.of(context).brandNormalColor,
                    ),
                    tabText: "书库",
                    unselectedIcon: const Icon(TDIcons.book),
                    onTap: () {
                      controller.setIndex(0);
                    }),
                TDBottomTabBarTabConfig(
                    selectedIcon: Icon(
                      TDIcons.download_2_filled,
                      color: TDTheme.of(context).brandNormalColor,
                    ),
                    tabText: "下载",
                    unselectedIcon: const Icon(TDIcons.download_2),
                    onTap: () {
                      controller.setIndex(1);
                    }),
                TDBottomTabBarTabConfig(
                    selectedIcon: Icon(
                      TDIcons.setting_filled,
                      color: TDTheme.of(context).brandNormalColor,
                    ),
                    unselectedIcon: const Icon(TDIcons.setting),
                    tabText: "设置",
                    onTap: () {
                      controller.setIndex(2);
                    }),
              ])),
    );
  }
}
