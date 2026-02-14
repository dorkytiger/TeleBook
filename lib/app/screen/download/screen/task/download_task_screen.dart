import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/download/screen/task/download_task_controller.dart';
import 'package:tele_book/app/widget/td/td_action_sheet_item_icon_widget.dart';

class DownloadTaskScreen extends GetView<DownloadTaskController> {
  const DownloadTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('下载任务')),
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
              () => ListTile(
                title: Text(task.filename),
                leading: () {
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
                                return Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: TDTheme.of(context).grayColor4,
                                );
                              },
                            ),
                          );
                        }
                        return SizedBox(
                          height: 100,
                          width: 80,
                          child: Icon(
                            Icons.image,
                            size: 50,
                            color: TDTheme.of(context).grayColor4,
                          ),
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
                          child: TDProgress(
                            value: task.progress.value,
                            type: TDProgressType.circular,
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
                subtitle: Text(
                  '状态: ${task.status.value.name}\n进度: ${(task.progress.value * 100).toStringAsFixed(1)}%',
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
            );
          },
        );
      }),
    );
  }
}
