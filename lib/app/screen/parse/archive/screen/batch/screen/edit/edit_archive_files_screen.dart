import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_controller.dart';
import 'package:tele_book/app/widget/custom_empty.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

import 'edit_archive_files_controller.dart';

class EditArchiveFilesScreen extends StatelessWidget {
  final ArchiveFolder archiveFolder;

  const EditArchiveFilesScreen({super.key, required this.archiveFolder});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditArchiveFilesController(archiveFolder: archiveFolder),
      child: const _EditArchiveFilesContent(),
    );
  }
}

class _EditArchiveFilesContent extends StatelessWidget {
  const _EditArchiveFilesContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<EditArchiveFilesController>(
      builder: (context, controller, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.archiveFolder.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () => context.pop(controller.buildUpdated()),
              ),
            ],
          ),
          body: controller.files.isEmpty
              ? const Center(child: CustomEmpty(message: '没有找到文件'))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '共 ${controller.files.length} 个文件',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '长按拖动排序',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ReorderableListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.files.length,
                        onReorder: controller.reorder,
                        itemBuilder: (context, index) {
                          final file = controller.files[index];
                          return KeyedSubtree(
                            key: ValueKey(file.path),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CustomImageLoader(localUrl: file.path),
                                    Expanded(
                                      child: ListTile(
                                        title: Text(file.path
                                            .split(Platform.pathSeparator)
                                            .last),
                                        subtitle: Text(file.path
                                            .split(Platform.pathSeparator)
                                            .last),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          controller.removeFile(index),
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16,)
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
