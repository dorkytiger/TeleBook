import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/error_widget.dart';
import 'package:tele_book/common/widget/task_item_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/download/enum/download_status.dart';
import 'package:tele_book/feature/download/model/bo/download_bo.dart';
import 'package:tele_book/feature/download/service/download_service.dart';
import 'package:tele_book/feature/download/ui/provider/download_provider.dart';

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

  void _showDownloadTaskList(
    BuildContext context,
    String groupId,
    WidgetRef ref,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final asyncTasks = ref.watch(downloadTasksProvider);

        return asyncTasks.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
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

            return Padding(
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
                      itemCount: tasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
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
                                    ref
                                        .read(downloadServiceProvider)
                                        .retryTask(task.id);
                                  },
                                  icon: const Icon(Icons.refresh),
                                )
                              : null,
                        );
                      },
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

  Future<void> _showDownloadForm(BuildContext context) async {
    final TextEditingController urlController = TextEditingController();
    final url = await showModalBottomSheet<String>(
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (sheetContext) {
        final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;
        return AnimatedPadding(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "添加下载任务",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    labelText: "下载链接",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.link),
                    suffixIcon: IconButton(
                      onPressed: () {
                        Clipboard.getData(Clipboard.kTextPlain).then((
                          clipData,
                        ) {
                          if (clipData != null && clipData.text != null) {
                            urlController.text = clipData.text!;
                          }
                        });
                      },
                      icon: const Icon(Icons.paste),
                    ),
                  ),
                  keyboardType: TextInputType.url,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      final inputUrl = urlController.text.trim();
                      Navigator.of(sheetContext).pop(inputUrl);
                    },
                    child: const Text("添加"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      urlController.dispose();
    });

    if (url == null || url.isEmpty || !context.mounted) return;
    context.push(AppRoute.parseWeb, extra: url);
  }
}
