import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/download/download_controller.dart';
import 'package:tele_book/app/widget/custom_empty.dart';

class DownloadScreen extends GetView<DownloadController> {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.downloadService.groups.entries.isEmpty) {
          return Center(child: CustomEmpty(message: "暂无下载任务"));
        }
        return ListView.builder(
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
    return ListTile(
      leading: firstTask?.url != null
          ? Image.network(firstTask!.url, fit: BoxFit.cover)
          : SizedBox(
              width: 100,
              height: 100,
              child: Icon(Icons.file_download, color: Colors.grey),
            ),
      title: Text(group.name),
      subtitle: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text(
              '总数: ${group.totalCount.value} | 完成: ${group.completedCount.value} | 失败: ${group.failedCount.value}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              '进度: ${(group.groupProgress.value * 100).toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            LinearProgressIndicator(value: group.groupProgress.value),
          ],
        ),
      ),
      trailing: PopupMenuButton<String>(
        itemBuilder: (context) {
          return [
            if (group.completedCount.value == group.totalCount.value)
              PopupMenuItem(value: "save", child: Text("保存到书架")),
            if (group.completedCount.value != group.totalCount.value)
              PopupMenuItem(value: "cancel", child: Text("取消下载")),
            PopupMenuItem(value: "resume", child: Text("继续下载")),
            PopupMenuItem(value: "pause", child: Text("暂停下载")),
            PopupMenuItem(value: "retry", child: Text("重试下载")),
            PopupMenuItem(value: "delete", child: Text("删除下载")),
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
      onTap: () {
        Get.toNamed(AppRoute.downloadTask, arguments: groupId);
      },
    );
  }
}
