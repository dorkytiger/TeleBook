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
    return Obx(
      () => ListTile(
        leading: firstTask?.url != null
            ? Image.network(
                firstTask!.url,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : SizedBox(
                width: 50,
                height: 50,
                child: Icon(Icons.file_download, color: Colors.grey),
              ),
        title: Text(group.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '总数: ${group.totalCount.value} | 完成: ${group.completedCount.value} | 失败: ${group.failedCount.value}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              '进度: ${(group.groupProgress.value * 100).toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            LinearProgressIndicator(value: 0.5),
          ],
        ),
        trailing: DropdownButton<String>(
          items: [
            DropdownMenuItem(value: "cancel", child: Text("取消下载")),
            DropdownMenuItem(value: "resume", child: Text("继续下载")),
            DropdownMenuItem(value: "delete", child: Text("删除下载")),
            DropdownMenuItem(value: "retry", child: Text("重新下载")),
          ],
          onChanged: (value) {
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
      ),
    );
  }
}

@Preview(name: "下载卡片预览")
Widget downloadScreenPreview() {
  return Material(
    child: ListTile(
      leading: Image.network(
        'https://picsum.photos/200/300',
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text("下载任务1"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '总数: 10 | 完成: 5 | 失败: 2',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text('进度: 50.0%', style: TextStyle(fontSize: 12, color: Colors.grey)),
          LinearProgressIndicator(value: 0.5),
        ],
      ),
      trailing: Icon(Icons.more_horiz),
    ),
  );
}
