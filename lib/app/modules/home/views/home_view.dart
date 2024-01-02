import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        body: PageView(
          controller: controller.pageController,
          children: controller.pages,
          onPageChanged: (index) {
            controller.currentPageCount(index);
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.blue,
          currentIndex: controller.currentPageCount.value,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            controller.setCurrentPage(index);
            controller.pageController.jumpToPage(index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "书籍"),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.video_collection), label: "视频"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "设置"),
          ],
        )));
  }
}
