import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:tele_book/common/widget/f_sheet_content.dart';
import 'package:tele_book/common/widget/task_item_widget.dart';
import 'package:tele_book/feature/download/enum/download_status.dart';
import 'package:tele_book/feature/download/service/download_service.dart';
import 'package:tele_book/feature/download/ui/provider/download_provider.dart';

class DownloadTaskSheetWidget extends ConsumerWidget {
  final String groupId;
  final String name;

  const DownloadTaskSheetWidget({required this.groupId, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTasks = ref.watch(downloadTasksProvider);

    return asyncTasks.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: FCircularProgress()),
      ),
      error: (e, st) => Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            "加载任务失败",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ),
      data: (groups) {
        final tasks = groups
            .where((g) => g.downloadGroupBo.id == groupId)
            .expand((g) => g.downloadItemBoList)
            .toList();

        if (tasks.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                "处理中",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        }

        return FSheetContent(
          side: .btt,
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              FSheetContent.title(context, "下载任务详情"),
              FSheetContent.subTitle(context,name),
              const SizedBox(height: 12),
              Expanded(
                child: FItemGroup.builder(
                  count: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskItemWidget(
                      title: task.url,
                      coverUrl: task.url,
                      status: task.status.description,
                      progress: task.progress,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (task.status == DownloadStatus.failed)
                            IconButton(
                              tooltip: '重试',
                              onPressed: () {
                                ref
                                    .read(downloadServiceProvider)
                                    .retryTask(task.id);
                              },
                              icon: const Icon(Icons.refresh),
                            ),
                          IconButton(
                            tooltip:
                                task.status == DownloadStatus.pending ||
                                    task.status == DownloadStatus.downloading ||
                                    task.status == DownloadStatus.paused
                                ? '下载中暂不支持删除'
                                : '删除任务项',
                            onPressed:
                                task.status == DownloadStatus.pending ||
                                    task.status == DownloadStatus.downloading ||
                                    task.status == DownloadStatus.paused
                                ? null
                                : () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (dialogContext) {
                                        return AlertDialog(
                                          title: const Text('删除任务项'),
                                          content: const Text(
                                            '删除后会重新检查剩余任务，若已经全部完成则会自动保存书籍，是否继续？',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(
                                                dialogContext,
                                              ).pop(false),
                                              child: const Text('取消'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => Navigator.of(
                                                dialogContext,
                                              ).pop(true),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                              ),
                                              child: const Text(
                                                '删除',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirmed != true || !context.mounted) {
                                      return;
                                    }

                                    try {
                                      await ref
                                          .read(downloadServiceProvider)
                                          .deleteTaskItem(task.id);
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      showFToast(
                                        context: context,
                                        title: Text("删除失败"),
                                        description: Text(e.toString()),
                                      );
                                    }
                                  },
                            icon: const Icon(FLucideIcons.trash),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
