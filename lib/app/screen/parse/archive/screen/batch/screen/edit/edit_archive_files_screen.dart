import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_controller.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/screen/edit/edit_archive_files_controller.dart';
import 'package:tele_book/app/widget/custom_empty.dart';

class EditArchiveFilesScreen extends GetView<EditArchiveFilesController> {
  const EditArchiveFilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.archiveFolder.title),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              controller.saveChanges();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.files.isEmpty) {
          return const Center(child: CustomEmpty(message: "没有找到文件"));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '共 ${controller.files.length} 个文件',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '长按拖动排序',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
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
      child: ListTile(
        title: Text(file.path.split(Platform.pathSeparator).last),
        subtitle: Text(file.path.split(Platform.pathSeparator).last),
        leading: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(File(file.path)),
        ),
        trailing: IconButton(
          onPressed: () {
            controller.removeFile(index);
          },
          icon: Icon(Icons.delete),
        ),
      ),
    );
  }
}
