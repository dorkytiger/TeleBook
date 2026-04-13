import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/screen/download/screen/task/download_task_controller.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

class DownloadTaskScreen extends GetView<DownloadTaskController> {
  const DownloadTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('下载任务')),
      body: Obx(() {
        final tasks =
            controller.downloadService.tasks.values
                .where((task) => task.groupId == controller.groupId)
                .toList()
              ..sort((a, b) => a.order.compareTo(b.order));
        return ListView.separated(
          padding: EdgeInsets.all(16),
          separatorBuilder: (context, index) => SizedBox(height: 16),
          itemCount: tasks.length,
          cacheExtent: 500,
          itemBuilder: (context, index) {
            final task = tasks.elementAt(index);
            return Row(
              children: [
                Obx(() {
                  if (task.status.value != TaskStatus.complete) {
                    return CustomImageLoader(networkUrl: task.url);
                  } else {
                    return FutureBuilder<String>(
                      future: controller.downloadService.getFullPath(
                        task.savePath.value,
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
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                    );
                  }
                }),
                Expanded(
                  child: Obx(
                    () => ListTile(
                      title: Text(
                        task.filename,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '状态: ${task.status.value.name} 进度: ${(task.progress.value * 100).toStringAsFixed(1)}%',
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(value: "resume", child: Text("继续")),
                            PopupMenuItem(value: "pause", child: Text("暂停")),
                            PopupMenuItem(value: "cancel", child: Text("删除")),
                            PopupMenuItem(value: "retry", child: Text("重试")),
                          ];
                        },
                        onSelected: (value) {
                          if (value == "resume") {
                            controller.downloadService.resume(task.taskId);
                          }
                          if (value == "pause") {
                            controller.downloadService.pause(task.taskId);
                          }
                          if (value == "cancel") {
                            controller.downloadService.cancel(task.taskId);
                          }
                          if (value == "retry") {
                            controller.downloadService.retry(task.taskId);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
