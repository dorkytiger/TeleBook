import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/widget/custom_empty.dart';

import 'import_controller.dart';

class ImportScreen extends GetView<ImportController> {
  const ImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.importService.groups.isEmpty) {
          return Center(child: CustomEmpty(message: "暂无导入任务"));
        }
        return ListView.builder(
          itemCount: controller.importService.groups.length,
          itemBuilder: (context, index) {
            final group = controller.importService.groups[index];
            final firstTask = group.tasks.firstOrNull;
            return Obx(
              () => ListTile(
                title: Text(group.name),
                leading: firstTask?.distSubPath != null &&
                        controller.appDocPath.value != null
                    ? Image.file(
                        File(
                          "${controller.appDocPath.value}/${firstTask!.distSubPath}",
                        ),
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.insert_drive_file),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      '总数: ${group.totalCount} | 完成: ${group.completedCount} | 失败: ${group.failedCount}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '进度: ${(group.groupProgress * 100).toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    LinearProgressIndicator(value: group.groupProgress),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    controller.importService.restartImport(group.id);
                  },
                  icon: Icon(Icons.refresh),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
