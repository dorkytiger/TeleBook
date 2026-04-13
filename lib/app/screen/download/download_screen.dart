import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/download/download_controller.dart';
import 'package:tele_book/app/widget/custom_empty.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

class DownloadScreen extends GetView<DownloadController> {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.downloadService.groups.entries.isEmpty) {
          return Center(child: CustomEmpty(message: "暂无下载任务"));
        }
        return ListView.separated(
          padding: EdgeInsets.all(16),
          separatorBuilder: (context, index) => SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = controller.downloadService.groups.entries.elementAt(
              index,
            );
            return _buildTaskItem(context, item.key);
          },
          itemCount: controller.downloadService.groups.entries.length,
        );
      }),
    );
  }

  Widget _buildTaskItem(BuildContext context, String groupId) {
    final group = controller.downloadService.groups[groupId]!;
    final firstTask = controller.downloadService
        .getTasksByGroup(groupId)
        .firstOrNull;

    return InkWell(
      onTap: () {
        Get.toNamed(AppRoute.downloadTask, arguments: groupId);
      },
      child: Row(
        children: [
          // 封面
          Obx(() {
            if (firstTask == null) {
              return Container(
                height: 80,
                width: 80,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.insert_drive_file,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              );
            }

            if (firstTask.status.value != TaskStatus.complete) {
              return CustomImageLoader(networkUrl: firstTask.url);
            } else {
              return FutureBuilder<String>(
                future: controller.downloadService.getFullPath(
                  firstTask.savePath.value,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return CustomImageLoader(localUrl: snapshot.data);
                  }
                  return Container(
                    height: 100,
                    width: 80,
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.insert_drive_file,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              );
            }
          }),
          Expanded(
            child: ListTile(
              title: Text(
                group.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text(
                      '总数: ${group.totalCount.value}  完成: ${group.completedCount.value}  失败: ${group.failedCount.value}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: group.groupProgress.value,
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 操作按钮
          MenuAnchor(
            menuChildren: [
              if (group.completedCount.value == group.totalCount.value)
                MenuItemButton(
                  leadingIcon: const Icon(Icons.save),
                  onPressed: () {
                    controller.savaToBook(groupId);
                  },
                  child: const Text("保存到书架"),
                ),
              if (group.completedCount.value != group.totalCount.value)
                MenuItemButton(
                  leadingIcon: const Icon(Icons.cancel),
                  onPressed: () {
                    controller.downloadService.cancelGroup(groupId);
                  },
                  child: const Text("取消下载"),
                ),
              MenuItemButton(
                leadingIcon: const Icon(Icons.play_arrow),
                onPressed: () {
                  controller.downloadService.resumeGroup(groupId);
                },
                child: const Text("继续下载"),
              ),
              MenuItemButton(
                leadingIcon: const Icon(Icons.pause),
                onPressed: () {
                  controller.downloadService.pauseGroup(groupId);
                },
                child: const Text("暂停下载"),
              ),
              MenuItemButton(
                leadingIcon: const Icon(Icons.refresh),
                onPressed: () {
                  controller.downloadService.retryGroup(groupId);
                },
                child: const Text("重试下载"),
              ),
              MenuItemButton(
                leadingIcon: const Icon(Icons.delete),
                onPressed: () {
                  controller.downloadService.deleteGroup(groupId);
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
          ),
        ],
      ),
    );
  }
}
