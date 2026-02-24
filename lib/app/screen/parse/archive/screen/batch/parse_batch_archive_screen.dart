import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_controller.dart';

class ParseBatchArchiveScreen extends GetView<ParseBatchArchiveController> {
  const ParseBatchArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("批量导入压缩包"),
      actions: [
        IconButton(
          onPressed: () {
            controller.saveAllBooks();
          },
          icon: Icon(Icons.save),
        ),
      ],
      ),
      body: controller.extractArchivesState.displaySuccess(
        successBuilder: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '共找到 ${controller.archiveFolders.length} 个压缩包',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.archiveFolders.length,
                  itemBuilder: (context, index) {
                    final archiveFolder = controller.archiveFolders[index];
                    return _buildArchiveItem(context, archiveFolder, index);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildArchiveItem(
    BuildContext context,
    ArchiveFolder archiveFolder,
    int index,
  ) {
    return ListTile(
      title: Text(archiveFolder.title),
      leading: AspectRatio(
        aspectRatio: 9 / 10,
        child: Image.file(
          File(
            archiveFolder.files.firstOrNull?.path ??
                '${controller.appDirectory}/${archiveFolder.files.first.path}',
          ),
        ),
      ),
      onTap: () {
        controller.editArchiveFolder(index);
      },
      subtitle: Text('${archiveFolder.files.length} 个文件'),
    );
  }
}
