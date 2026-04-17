import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/download/download_screen.dart';
import 'package:tele_book/app/screen/export/export_screen.dart';
import 'package:tele_book/app/screen/import/import_screen.dart';
import 'task_controller.dart';

/// TaskScreen - 使用 Provider 模式
/// 使用 StatefulWidget 来提供 TickerProvider
class TaskScreen extends StatefulWidget {
  final int? initialTab; // 初始显示的 tab（0=下载, 1=导入, 2=导出）

  const TaskScreen({super.key, this.initialTab});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with SingleTickerProviderStateMixin {
  late final TaskController _controller;

  @override
  void initState() {
    super.initState();
    // 创建 Controller 并初始化 TabController
    _controller = TaskController();
    _controller.initTabController(this, initialIndex: widget.initialTab ?? 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskController>.value(
      value: _controller,
      child: Consumer<TaskController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('任务管理'),
              actions: [
                IconButton(
                  onPressed: () {
                    // 使用 go_router 进行导航（替代 Get.toNamed）
                    context.go(AppRoute.parseForm);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: controller.tabController == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      TabBar(
                        controller: controller.tabController,
                        tabs: const [
                          Tab(child: Text("下载")),
                          Tab(child: Text("导入")),
                          Tab(child: Text("导出")),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: controller.tabController,
                          children: const [
                            DownloadScreen(),
                            ImportScreen(),
                            ExportScreen(),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
