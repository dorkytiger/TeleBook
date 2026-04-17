import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/download/download_controller.dart';
import 'package:tele_book/app/store/download_store.dart';
import 'package:tele_book/app/widget/custom_empty.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          DownloadController(downloadStore: context.read<DownloadStore>()),
      child: const _DownloadScreenContent(),
    );
  }
}

class _DownloadScreenContent extends StatelessWidget {
  const _DownloadScreenContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadController>(
      builder: (context, controller, child) {
        return Scaffold(
          body: controller.isEmpty
              ? const Center(child: CustomEmpty(message: "暂无下载任务"))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = controller.groups[index];
                    return _DownloadGroupItem(
                      groupId: item.key,
                      group: item.value,
                    );
                  },
                  itemCount: controller.groups.length,
                ),
        );
      },
    );
  }
}

class _DownloadGroupItem extends StatelessWidget {
  final String groupId;
  final DownloadGroupInfo group;

  const _DownloadGroupItem({required this.groupId, required this.group});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DownloadController>();
    final firstTask = controller.getTasksByGroup(groupId).firstOrNull;

    return InkWell(
      onTap: () {
        context.push(AppRoute.downloadTask, extra: groupId);
      },
      child: Row(
        children: [
          // 封面
          _buildCover(context, controller, firstTask),
          const SizedBox(width: 12),
          // 信息
          Expanded(child: _buildInfo(context, group)),
          // 操作按钮
          _buildMenu(context, controller, group),
        ],
      ),
    );
  }

  Widget _buildCover(
    BuildContext context,
    DownloadController controller,
    DownloadTaskInfo? firstTask,
  ) {
    if (firstTask == null) {
      return _buildPlaceholder(context);
    }

    if (firstTask.status != TaskStatus.complete) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 60,
          height: 80,
          child: CustomImageLoader(networkUrl: firstTask.url),
        ),
      );
    }

    // 已完成，显示本地文件
    return FutureBuilder<String?>(
      future: controller.getTaskFullPath(firstTask.taskId),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return CustomImageLoader(localUrl: snapshot.data);
        }
        return _buildPlaceholder(context);
      },
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 60,
        height: 80,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.insert_drive_file,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context, DownloadGroupInfo group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Text(
          group.name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '总数: ${group.totalCount}  完成: ${group.completedCount}  失败: ${group.failedCount}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: group.groupProgress,
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildMenu(
    BuildContext context,
    DownloadController controller,
    DownloadGroupInfo group,
  ) {
    return MenuAnchor(
      menuChildren: [
        if (group.completedCount == group.totalCount)
          MenuItemButton(
            leadingIcon: const Icon(Icons.save),
            onPressed: () async {
              try {
                await controller.saveToBook(groupId);
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('已保存到书架')));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
                }
              }
            },
            child: const Text("保存到书架"),
          ),
        if (group.completedCount != group.totalCount)
          MenuItemButton(
            leadingIcon: const Icon(Icons.cancel),
            onPressed: () => controller.cancelGroup(groupId),
            child: const Text("取消下载"),
          ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.play_arrow),
          onPressed: () => controller.resumeGroup(groupId),
          child: const Text("继续下载"),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.pause),
          onPressed: () => controller.pauseGroup(groupId),
          child: const Text("暂停下载"),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.refresh),
          onPressed: () => controller.retryGroup(groupId),
          child: const Text("重试下载"),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.delete),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('确认删除'),
                content: Text('确定要删除 ${group.name} 吗？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('取消'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: const Text('删除'),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              await controller.deleteGroup(groupId);
            }
          },
          child: const Text("删除下载"),
        ),
      ],
      builder: (btnContext, menuController, child) => IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () => menuController.isOpen
            ? menuController.close()
            : menuController.open(),
      ),
    );
  }
}
