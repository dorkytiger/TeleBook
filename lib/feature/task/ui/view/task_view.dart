import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/download/ui/view/download_list_view.dart';
import 'package:tele_book/feature/task/store/task_store.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TaskStore>();
    tabController.index = store.taskTabIndex;
    return Scaffold(
      appBar: AppBar(
        title: Text('任务'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              context.push(AppRoute.parseForm);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            onTap: (index) {
              store.updateTaskTabIndex(index);
            },
            tabs: [
              Tab(text: '下载'),
              Tab(text: '导入'),
              Tab(text: '导出'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                DownloadListView(),
                Center(child: Text('导入任务')),
                Center(child: Text('导出任务')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
