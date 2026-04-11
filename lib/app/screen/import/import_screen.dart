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
          padding: EdgeInsets.all(16),
          itemCount: controller.importService.groups.length,
          itemBuilder: (context, index) {
            final group = controller.importService.groups[index];
            final firstTask = group.tasks.firstOrNull;
            return Obx(
              () => Card(
                margin: EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // 封面
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 60,
                          height: 90,
                          child: firstTask?.distSubPath.value != null &&
                                  firstTask!.distSubPath.value.isNotEmpty &&
                                  controller.appDocPath.value != null
                              ? Image.file(
                                  File(
                                    "${controller.appDocPath.value}/${firstTask.distSubPath.value}",
                                  ),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                        child: Icon(
                                          Icons.insert_drive_file,
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                )
                              : Container(
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  child: Icon(
                                    Icons.insert_drive_file,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // 信息区域
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 6,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.task_alt,
                                      size: 14,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '总数: ${group.totalCount}  完成: ${group.completedCount}  失败: ${group.failedCount}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.pending,
                                      size: 14,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '进度: ${(group.groupProgress * 100).toStringAsFixed(1)}%',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: group.groupProgress,
                                    minHeight: 6,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      // 重试按钮
                      IconButton(
                        onPressed: () {
                          controller.importService.restartImport(group.id);
                        },
                        icon: Icon(Icons.refresh),
                        tooltip: '重新导入',
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
