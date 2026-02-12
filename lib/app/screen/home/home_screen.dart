import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/book/book_screen.dart';
import 'package:tele_book/app/screen/collection/collection_screen.dart';
import 'package:tele_book/app/screen/import/import_screen.dart';
import 'package:tele_book/app/screen/manage/manage_screen.dart';
import 'package:tele_book/app/screen/mark/mark_screen.dart';
import 'package:tele_book/app/screen/setting/setting_screen.dart';
import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() {
          return IndexedStack(
            index: controller.selectedIndex.value,
            children: const [
              BookScreen(),
              ImportScreen(),
              CollectionScreen(),
              MarkScreen(),
            ],
          );
        }),
        bottomNavigationBar: Obx(() =>
            NavigationBar(
              selectedIndex: controller.selectedIndex.value,
              onDestinationSelected: (index) {
                controller.selectedIndex.value = index;
              },
              destinations: [
                NavigationDestination(icon: Icon(Icons.book), label: '书架'),
                NavigationDestination(
                    icon: Icon(Icons.file_upload), label: '导入'),
                NavigationDestination(
                    icon: Icon(TDIcons.collection), label: '收藏'),
                NavigationDestination(
                    icon: Icon(Icons.bookmark), label: '书签'),
              ],
            ),
        ));
  }
}
