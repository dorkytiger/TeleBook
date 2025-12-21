import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_controller.dart';

class EditArchiveFilesController extends GetxController {
  late ArchiveFolder archiveFolder;
  final files = <ArchiveFile>[].obs;

  @override
  void onInit() {
    super.onInit();
    archiveFolder = Get.arguments as ArchiveFolder;
    files.addAll(archiveFolder.files);
  }

  /// 删除文件
  void removeFile(int index) {
    files.removeAt(index);
  }

  /// 上移文件
  void moveUp(int index) {
    if (index > 0) {
      final file = files.removeAt(index);
      files.insert(index - 1, file);
    }
  }

  /// 下移文件
  void moveDown(int index) {
    if (index < files.length - 1) {
      final file = files.removeAt(index);
      files.insert(index + 1, file);
    }
  }

  /// 保存修改
  void saveChanges() {
    final updatedFolder = archiveFolder.copyWith(files: files.toList());
    Get.back(result: updatedFolder);
  }

  /// 获取文件名
  String getFileName(String path) {
    return p.basename(path);
  }

  /// 获取文件大小
  Future<String> getFileSize(String path) async {
    try {
      final file = File(path);
      final bytes = await file.length();
      if (bytes < 1024) {
        return '$bytes B';
      } else if (bytes < 1024 * 1024) {
        return '${(bytes / 1024).toStringAsFixed(1)} KB';
      } else {
        return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}

