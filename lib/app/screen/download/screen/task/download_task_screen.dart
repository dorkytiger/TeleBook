import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

import 'download_task_controller.dart';

class DownloadTaskScreen extends StatelessWidget {
  final String groupId;

  const DownloadTaskScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DownloadTaskController(
        groupId: groupId,
        downloadStore: context.read(),
      ),
      child: const _DownloadTaskContent(),
    );
  }
}

class _DownloadTaskContent extends StatelessWidget {
  const _DownloadTaskContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadTaskController>(
      builder: (context, controller, _) {
        final tasks = controller.tasks;
        return Scaffold(
          appBar: AppBar(title: Text('下载任务')),
          body: ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemCount: tasks.length,
            cacheExtent: 500,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Row(
                children: [
                  // 封面图：完成后显示本地图，否则显示网络预览
                  task.status == TaskStatus.complete
                      ? CustomImageLoader(
                          localUrl: controller.getFilePath(task.savePath),
                        )
                      : CustomImageLoader(networkUrl: task.url),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        task.filename,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '状态: ${task.status.name}  '
                        '进度: ${(task.progress * 100).toStringAsFixed(1)}%',
                      ),
                      trailing: MenuAnchor(
                        menuChildren: [
                          MenuItemButton(
                            leadingIcon: const Icon(Icons.play_arrow),
                            onPressed: () => controller.resume(task.taskId),
                            child: const Text('继续'),
                          ),
                          MenuItemButton(
                            leadingIcon: const Icon(Icons.pause),
                            onPressed: () => controller.pause(task.taskId),
                            child: const Text('暂停'),
                          ),
                          MenuItemButton(
                            leadingIcon: const Icon(Icons.delete),
                            onPressed: () => controller.cancel(task.taskId),
                            child: const Text('删除'),
                          ),
                          MenuItemButton(
                            leadingIcon: const Icon(Icons.refresh),
                            onPressed: () => controller.retry(task.taskId),
                            child: const Text('重试'),
                          ),
                        ],
                        builder: (_, menuController, __) => IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () => menuController.isOpen
                              ? menuController.close()
                              : menuController.open(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _placeholder(BuildContext context) => Container(
    height: 100,
    width: 80,
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: Icon(
      Icons.insert_drive_file,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
}
