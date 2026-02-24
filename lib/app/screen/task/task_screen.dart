import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/download/download_screen.dart';
import 'package:tele_book/app/screen/export/export_screen.dart';
import 'package:tele_book/app/screen/import/import_screen.dart';
import 'task_controller.dart';

class TaskScreen extends GetView<TaskController> {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('任务管理'),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoute.bookForm);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: controller.tabController,
            tabs: [
              Tab(child: Text("下载")),
              Tab(child: Text("导入")),
              Tab(child: Text("导出")),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [DownloadScreen(), ImportScreen(), ExportScreen()],
            ),
          ),
        ],
      ),
    );
  }
}
