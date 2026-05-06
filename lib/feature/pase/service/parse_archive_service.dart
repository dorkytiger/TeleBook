import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/util/failure_util.dart';
import 'package:tele_book/core/util/result_util.dart';
import 'package:uuid/uuid.dart';
import 'package:archive/archive_io.dart';

class ParseArchiveService {
  Future<Result<List<String>>> parseArchive(String archivePath) async {
    try {
      final tempOutputDir = "${GlobalConfig.appTempDir.path}/${Uuid().v4()}";
      await extractFileToDisk(archivePath, tempOutputDir);
      final outputDir = Directory(tempOutputDir);
      final imagePaths = outputDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => _isImageFile(file.path))
          .map((file) => file.path)
          .toList();
      return Result.success(imagePaths);
    } catch (e, startTrace) {
      return Result.failure(
        BusinessFailure(message: "解析压缩包失败", details: e, stackTrace: startTrace),
      );
    }
  }

  bool _isImageFile(String path) {
    final lowerPath = path.toLowerCase();
    return lowerPath.endsWith('.jpg') ||
        lowerPath.endsWith('.jpeg') ||
        lowerPath.endsWith('.png') ||
        lowerPath.endsWith('.gif') ||
        lowerPath.endsWith('.bmp') ||
        lowerPath.endsWith('.webp');
  }
}
