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
        return ListView.separated(
          padding: EdgeInsets.all(16),
          separatorBuilder: (context, index) => SizedBox(height: 16),
          itemCount: controller.importService.groups.length,
          itemBuilder: (context, index) {
            final group = controller.importService.groups[index];
            final firstTask = group.tasks.firstOrNull;
            return Obx(
              () => Row(
                children: [
                  // 封面
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child:
                          firstTask?.distSubPath.value != null &&
                              firstTask!.distSubPath.value.isNotEmpty &&
                              controller.appDocPath.value != null
                          ? Image.file(
                              File(
                                "${controller.appDocPath.value}/${firstTask.distSubPath.value}",
                              ),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                                    child: Icon(
                                      Icons.insert_drive_file,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                            )
                          : Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.insert_drive_file,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // 信息区域
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          group.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        Text(
                          '总数: ${group.totalCount}  完成数: ${group.completedCount}  失败数: ${group.failedCount}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withValues(alpha: 0.7),
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
            );
          },
        );
      }),
    );
  }
}
