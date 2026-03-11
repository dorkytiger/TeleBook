import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/screen/book/book_screen.dart';
import 'package:tele_book/app/screen/collection/collection_screen.dart';
import 'package:tele_book/app/screen/mark/mark_screen.dart';
import 'package:tele_book/app/screen/task/task_screen.dart';

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
            TaskScreen(),
            CollectionScreen(),
            MarkScreen(),
          ],
        );
      }),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) {
            controller.selectedIndex.value = index;
          },
          destinations: [
            NavigationDestination(icon: Icon(Icons.book), label: '书架'),
            NavigationDestination(icon: Icon(Icons.task), label: '任务'),
            NavigationDestination(
              icon: Icon(Icons.collections_bookmark),
              label: '收藏',
            ),
            NavigationDestination(icon: Icon(Icons.bookmark), label: '书签'),
          ],
        ),
      ),
    );
  }
}
