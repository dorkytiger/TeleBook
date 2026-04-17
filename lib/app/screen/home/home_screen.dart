import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tele_book/app/screen/book/book_screen.dart';
import 'package:tele_book/app/screen/collection/collection_screen.dart';
import 'package:tele_book/app/screen/mark/mark_screen.dart';
import 'package:tele_book/app/screen/task/task_screen.dart';

import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  final int? initialTab; // 初始显示的主 tab（0=书架, 1=任务, 2=收藏, 3=书签）
  final int? initialTaskTab; // 任务页面的初始 tab（0=下载, 1=导入, 2=导出）

  const HomeScreen({
    super.key,
    this.initialTab,
    this.initialTaskTab,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(
        selectedIndex: initialTab ?? 0,
        taskTabIndex: initialTaskTab,
      ),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, child) {
        return Scaffold(
          body: IndexedStack(
            index: controller.selectedIndex,
            children: [
              const BookScreen(),
              TaskScreen(initialTab: controller.taskTabIndex ?? 0),
              const CollectionScreen(),
              const MarkScreen(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: controller.selectedIndex,
            onDestinationSelected: (index) {
              controller.onTabSelected(index);
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.book), label: '书架'),
              NavigationDestination(icon: Icon(Icons.task), label: '任务'),
              NavigationDestination(
                icon: Icon(Icons.collections_bookmark),
                label: '收藏',
              ),
              NavigationDestination(icon: Icon(Icons.bookmark), label: '书签'),
            ],
          ),
        );
      },
    );
  }
}
