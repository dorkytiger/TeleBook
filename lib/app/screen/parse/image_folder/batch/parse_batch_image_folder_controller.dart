import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_query_helper.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:tele_book/app/store/import_store.dart';

class ParseBatchImageFolderController extends ChangeNotifier {
  final String parentFolderPath;
  final ImportStore importStore;

  List<ImageFolderInfo> imageFolders = [];
  DKStateQuery<List<ImageFolderInfo>> scanFoldersState = DkStateQueryIdle();

  static const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];

  ParseBatchImageFolderController({
    required this.parentFolderPath,
    required this.importStore,
  }) {
    scanImageFolders();
  }

  Future<void> scanImageFolders() async {
    await DKStateQueryHelper.triggerQuery(
      onStateChange: (value) {
        scanFoldersState = value;
        notifyListeners();
      },
      query: () async {
        final parentFolder = Directory(parentFolderPath);
        if (!await parentFolder.exists()) throw Exception('文件夹不存在');

        final folders = <ImageFolderInfo>[];
        await for (final entity in parentFolder.list()) {
          if (entity is Directory) {
            final images = <File>[];
            await for (final file in entity.list()) {
              if (file is File &&
                  imageExtensions
                      .contains(p.extension(file.path).toLowerCase())) {
                images.add(file);
              }
            }
            if (images.isNotEmpty) {
              images.sort((a, b) =>
                  p.basename(a.path).compareTo(p.basename(b.path)));
              folders.add(ImageFolderInfo(
                folderPath: entity.path,
                folderName: p.basename(entity.path),
                images: images,
              ));
            }
          }
        }
        if (folders.isEmpty) throw Exception('没有找到包含图片的文件夹');
        folders.sort((a, b) => a.folderName.compareTo(b.folderName));
        imageFolders = folders;
        return folders;
      },
    );
  }

  Future<void> saveAllToLocal() async {
    if (imageFolders.isEmpty) throw Exception('没有可保存的文件夹');
    int successCount = 0;
    for (final folderInfo in imageFolders) {
      try {
        final group = await importStore.buildImportGroup(
          name: folderInfo.folderName,
          type: ImportType.folderWithSubfolders,
          files: folderInfo.images,
        );
        importStore.addImportGroup(group);
        await importStore.startImport(group);
        if (group.status.value != ImportStatus.failed) successCount++;
      } catch (e) {
        debugPrint('保存文件夹 ${folderInfo.folderName} 失败: $e');
      }
    }
    if (successCount == 0) throw Exception('没有成功保存任何书籍');
  }
}

class ImageFolderInfo {
  final String folderPath;
  final String folderName;
  final List<File> images;

  ImageFolderInfo({
    required this.folderPath,
    required this.folderName,
    required this.images,
  });
}
