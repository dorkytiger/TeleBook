import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_query_helper.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:tele_book/app/store/import_store.dart';

class ParseImageFolderController extends ChangeNotifier {
  final String folderPath;
  final ImportStore importStore;

  List<File> images = [];
  DKStateQuery<List<File>> scanImageState = DkStateQueryIdle();

  // 支持的图片格式
  static const imageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.bmp',
    '.webp',
  ];

  ParseImageFolderController({
    required this.folderPath,
    required this.importStore,
  }) {
    scanImages();
  }

  Future<void> scanImages() async {
    await DKStateQueryHelper.triggerQuery(
      onStateChange: (value) {
        scanImageState = value;
        notifyListeners();
      },
      query: () async {
        final folder = Directory(folderPath);
        if (!await folder.exists()) {
          throw Exception("文件夹不存在");
        }

        final files = <File>[];
        await for (final entity in folder.list()) {
          if (entity is File) {
            final ext = p.extension(entity.path).toLowerCase();
            if (imageExtensions.contains(ext)) {
              files.add(entity);
            }
          }
        }

        if (files.isEmpty) {
          throw Exception("文件夹中没有找到图片文件");
        }

        // 按文件名排序
        files.sort((a, b) => p.basename(a.path).compareTo(p.basename(b.path)));
        images = files;
        return files;
      },
    );
  }

  Future<void> saveImagesToLocal() async {
    if (images.isEmpty) {
      throw Exception("没有可保存的图片");
    }
    final title = p.basename(folderPath);
    final group = await importStore.buildImportGroup(
      name: title,
      type: ImportType.folder,
      files: images,
    );
    importStore.addImportGroup(group);
    await importStore.startImport(group);

    if (group.status.value == ImportStatus.failed) {
      throw Exception("导入失败");
    }
  }
}
