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
          PopupMenuButton<String>(
            itemBuilder: (context) {
              return [
                if (group.completedCount.value == group.totalCount.value)
                  PopupMenuItem(
                    value: "save",
                    child: Row(
                      children: [
                        Icon(Icons.save),
                        SizedBox(width: 8),
                        Text("保存到书架"),
                      ],
                    ),
                  ),
                if (group.completedCount.value != group.totalCount.value)
                  PopupMenuItem(
                    value: "cancel",
                    child: Row(
                      children: [
                        Icon(Icons.cancel),
                        SizedBox(width: 8),
                        Text("取消下载"),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: "resume",
                  child: Row(
                    children: [
                      Icon(Icons.play_arrow),
                      SizedBox(width: 8),
                      Text("继续下载"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "pause",
                  child: Row(
                    children: [
                      Icon(Icons.pause),
                      SizedBox(width: 8),
                      Text("暂停下载"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "retry",
                  child: Row(
                    children: [
                      Icon(Icons.refresh),
                      SizedBox(width: 8),
                      Text("重试下载"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "delete",
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 8),
                      Text("删除下载"),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (value) {
              if (value == "save") {
                controller.savaToBook(groupId);
              }
              if (value == "cancel") {
                controller.downloadService.cancelGroup(groupId);
              }
              if (value == "resume") {
                controller.downloadService.resumeGroup(groupId);
              }
              if (value == "delete") {
                controller.downloadService.deleteGroup(groupId);
              }
              if (value == "retry") {
                controller.downloadService.retryGroup(groupId);
              }
            },
          ),
        ],
      ),
    );
  }
}
