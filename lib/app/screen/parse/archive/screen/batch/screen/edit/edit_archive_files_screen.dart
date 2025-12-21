import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_controller.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/screen/edit/edit_archive_files_controller.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

class EditArchiveFilesScreen extends GetView<EditArchiveFilesController> {
  const EditArchiveFilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: controller.archiveFolder.title,
        onBack: () {
          Get.back();
        },
        rightBarItems: [
          TDNavBarItem(
            icon: Icons.check,
            action: () {
              controller.saveChanges();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.files.isEmpty) {
          return const Center(child: TDText('没有文件'));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TDText(
                    '共 ${controller.files.length} 个文件',
                    font: TDTheme.of(context).fontBodyLarge,
                    fontWeight: FontWeight.bold,
                  ),
                  TDText(
                    '长按拖动排序',
                    font: TDTheme.of(context).fontBodyMedium,
                    textColor: TDTheme.of(context).fontGyColor3,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: controller.files.length,
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final file = controller.files.removeAt(oldIndex);
                  controller.files.insert(newIndex, file);
                },
                itemBuilder: (context, index) {
                  final file = controller.files[index];
                  return _buildFileItem(context, file, index);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFileItem(BuildContext context, ArchiveFile file, int index) {
    return KeyedSubtree(
      key: ValueKey(file.path),
      child: TDCell(
        title: file.path.split(Platform.pathSeparator).last,
        description: file.path.split(Platform.pathSeparator).last,
        leftIconWidget: CustomImageLoader(localUrl: file.path),
        onClick: (cell) {
          TDActionSheet(
            context,
            visible: true,
            items: [TDActionSheetItem(label: '删除文件')],
            onSelected: (actionItem, actionIndex) {
              if (actionIndex == 0) {
                controller.removeFile(index);
              }
            },
          );
        },
      ),
    );
  }
}
