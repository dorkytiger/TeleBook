import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/common/widget/task_item_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/download/enum/download_status.dart';
import 'package:tele_book/feature/download/model/bo/download_bo.dart';
import 'package:tele_book/feature/download/store/download_store.dart';

class DownloadListView extends StatelessWidget {
  const DownloadListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DownloadListContent();
  }
}

class _DownloadListContent extends StatefulWidget {
  const _DownloadListContent();

  @override
  State<_DownloadListContent> createState() => _DownloadListContentState();
}

class _DownloadListContentState extends State<_DownloadListContent> {
  double _groupProgressPercent(List<DownloadItemBo> items) {
    if (items.isEmpty) return 0;
    final total = items.fold<double>(0, (sum, item) => sum + item.progress);
    return (total / items.length).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<DownloadStore>();
    return Scaffold(
      appBar: AppBar(
        title: Text("下载任务"),
        leading: BackButton(
          onPressed: () {
            context.go(AppRoute.book);
          },
        ),
      ),
      body: store.tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "暂无下载任务",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(16),
              separatorBuilder: (context, index) => SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = store.tasks[index];
                final progressPercent = _groupProgressPercent(
                  item.downloadItemBoList,
                );
                return TaskItemWidget(
                  title: item.downloadGroupBo.name,
                  coverUrl: item.downloadItemBoList.first.url,
                  status: item.downloadGroupBo.status.description,
                  progress: progressPercent,
                  onTap: () =>
                      _showDownloadTaskList(context, item.downloadGroupBo.id),
                );
              },
              itemCount: store.tasks.length,
            ),
    );
  }

  void _showDownloadTaskList(BuildContext context, String groupId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer<DownloadStore>(
          builder: (context, store, _) {
            final tasks = store.tasks
                .where((task) => task.downloadGroupBo.id == groupId)
                .expand((task) => task.downloadItemBoList)
                .toList();

            if (tasks.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    "处理中",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "下载任务详情",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final task = tasks[index];

                        return TaskItemWidget(
                          title: task.url,
                          coverUrl: task.url,
                          status: task.status.description,
                          progress: task.progress,
                          trailing: task.status == DownloadStatus.failed
                              ? IconButton(
                                  onPressed: () {
                                    store.retryDownload(task.id);
                                  },
                                  icon: Icon(Icons.refresh),
                                )
                              : null,
                        );
                      },
                      itemCount: tasks.length,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
