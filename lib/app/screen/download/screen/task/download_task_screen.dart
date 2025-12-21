import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/download/screen/task/download_task_controller.dart';

class DownloadTaskScreen extends GetView<DownloadTaskController> {
  const DownloadTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(title: '下载任务'),
      body: Obx(() {
        final tasks = controller.downloadService.tasks.values.where(
          (task) => task.groupId == controller.groupId,
        );
        return ListView.builder(
          itemCount: tasks.length,
          cacheExtent: 500,
          itemBuilder: (context, index) {
            final task = tasks.elementAt(index);
            return Obx(
              () => TDCell(
                title: task.filename,
                leftIconWidget: () {
                  if (task.status.value == TaskStatus.complete &&
                      task.savePath.value.isNotEmpty) {
                    // 使用 FutureBuilder 动态获取完整路径
                    return FutureBuilder<String>(
                      future: controller.downloadService.getFullPath(
                        task.savePath.value,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return SizedBox(
                            height: 100,
                            width: 80,
                            child: Image.file(
                              File(snapshot.data!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, size: 50);
                              },
                            ),
                          );
                        }
                        return const SizedBox(
                          height: 100,
                          width: 80,
                          child: Icon(Icons.image, size: 50),
                        );
                      },
                    );
                  }
                  if (task.status.value == TaskStatus.running) {
                    return SizedBox(
                      height: 100,
                      width: 80,
                      child: Center(
                        child: SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            value: task.progress.value,
                            color: TDTheme.of(context).brandNormalColor,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    height: 100,
                    width: 80,
                    child: Icon(
                      Icons.downloading,
                      size: 32,
                      color: TDTheme.of(context).brandNormalColor,
                    ),
                  );
                }(),
                description:
                    '状态: ${task.status.value.name}\n进度: ${(task.progress.value * 100).toStringAsFixed(1)}%',
                noteWidget: TDButton(
                  icon: Icons.more_horiz_outlined,
                  type: TDButtonType.text,
                  onTap: () {
                    TDActionSheet(
                      context,
                      visible: true,
                      onSelected: (actionItem, actionIndex) {
                        if (actionIndex == 0) {
                          controller.downloadService.resume(task.taskId);
                        }
                        if (actionIndex == 1) {
                          controller.downloadService.pause(task.taskId);
                        }
                        if (actionIndex == 2) {
                          controller.downloadService.cancel(task.taskId);
                        }
                        if (actionIndex == 3) {
                          controller.downloadService.retry(task.taskId);
                        }
                      },
                      items: [
                        TDActionSheetItem(label: "继续下载"),
                        TDActionSheetItem(label: "暂停下载"),
                        TDActionSheetItem(label: "删除任务"),
                        TDActionSheetItem(label: "重试下载"),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
