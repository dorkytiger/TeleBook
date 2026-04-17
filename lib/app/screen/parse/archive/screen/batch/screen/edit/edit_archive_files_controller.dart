import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_controller.dart';

class EditArchiveFilesController extends ChangeNotifier {
  final ArchiveFolder archiveFolder;
  List<ArchiveFile> files;

  EditArchiveFilesController({required this.archiveFolder})
      : files = List.from(archiveFolder.files);

  /// 删除文件
  void removeFile(int index) {
    files.removeAt(index);
    notifyListeners();
  }

  /// 移动文件
  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final file = files.removeAt(oldIndex);
    files.insert(newIndex, file);
    notifyListeners();
  }

  /// 构建更新后的文件夹
  ArchiveFolder buildUpdated() => archiveFolder.copyWith(files: files);

  /// 获取文件名
  String getFileName(String path) => p.basename(path);

  /// 获取文件大小
  Future<String> getFileSize(String path) async {
    try {
      final bytes = await File(path).length();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (_) {
      return 'Unknown';
    }
  }
}
