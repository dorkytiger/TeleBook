import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/error_widget.dart';
import 'package:tele_book/common/widget/task_item_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/download/enum/download_status.dart';
import 'package:tele_book/feature/download/model/bo/download_bo.dart';
import 'package:tele_book/feature/download/service/download_service.dart';
import 'package:tele_book/feature/download/ui/provider/download_provider.dart';
import 'package:tele_book/feature/download/ui/widget/download_form_bottom_sheet_widget.dart';
import 'package:tele_book/feature/download/ui/widget/download_task_sheet_widget.dart';

class DownloadListView extends ConsumerWidget {
  const DownloadListView({super.key});

  double _groupProgressPercent(List<DownloadItemBo> items) {
    if (items.isEmpty) return 0;
    final total = items.fold<double>(0, (sum, item) => sum + item.progress);
    return (total / items.length).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(downloadTasksProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("下载任务"),
        actions: [
          IconButton(
            tooltip: '清空已完成任务',
            onPressed: () async {
              await _clearCompletedTasks(context, ref);
            },
            icon: const Icon(Icons.delete_sweep),
          ),
          IconButton(
            onPressed: () async {
              await _showDownloadForm(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),

      body: state.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: CustomErrorWidget(errorMessage: "加载下载任务失败", stackTrace: st),
        ),
        data: (tasks) {
          return tasks.isEmpty
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
                    final item = tasks[index];
                    final progressPercent = _groupProgressPercent(
                      item.downloadItemBoList,
                    );
                    return TaskItemWidget(
                      title: item.downloadGroupBo.name,
                      coverUrl: item.downloadItemBoList.first.url,
                      status: item.downloadGroupBo.status.description,
                      progress: progressPercent,
                      onTap: () => _showDownloadTaskList(
                        context,
                        item.downloadGroupBo.id,
                        ref,
                      ),
                    );
                  },
                  itemCount: tasks.length,
                );
        },
      ),
    );
  }

  Future<void> _clearCompletedTasks(BuildContext context, WidgetRef ref) async {
    final tasks = await ref.read(downloadTasksProvider.future);
    final hasCompleted = tasks.any(
      (group) => group.downloadGroupBo.status == DownloadStatus.completed,
    );
    if (!hasCompleted) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('没有可清空的已完成任务')));
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('清空已完成任务'),
          content: const Text('将移除所有已完成的下载任务组及其临时文件，是否继续？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('清空', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final clearedCount = await ref
          .read(downloadServiceProvider)
          .clearCompletedTasks();
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('已清空 $clearedCount 个已完成任务')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _showDownloadTaskList(
    BuildContext context,
    String groupId,
    WidgetRef ref,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => DownloadTaskSheetWidget(groupId: groupId),
    );
  }

  Future<void> _showDownloadForm(BuildContext context) async {
    final url = await showModalBottomSheet<String>(
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (sheetContext) {
        return DownloadFormBottomSheetWidget();
      },
    );

    if (url == null || url.isEmpty || !context.mounted) return;
    context.push(AppRoute.parseWeb, extra: url);
  }
}
