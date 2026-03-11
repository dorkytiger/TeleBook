import 'dart:async';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Value;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/home/home_controller.dart';
import 'package:tele_book/app/screen/task/task_controller.dart';
import 'package:tele_book/app/service/import_service.dart';

class ParseBatchArchiveController extends GetxController {
  final folderPath = Get.arguments as String;
  final extractArchivesState = Rx<DKStateQuery<void>>(DkStateQueryIdle());
  final saveAllBooksState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final extractArchiveProgress = 0.obs;
  final extractArchiveTotal = 0.obs;
  final archiveFolders = <ArchiveFolder>[].obs;
  final importService = Get.find<ImportService>();
  final appDir = RxnString();

  @override
  void onInit() async {
    super.onInit();
    saveAllBooksState.listenEvent(
      onSuccess: (_) {
        Get.back();
        final homeController = Get.find<HomeController>();
        homeController.selectedIndex.value = 1;
        final taskController = Get.find<TaskController>();
        taskController.tabController.animateTo(1);
      },
    );
    appDir.value = (await getApplicationDocumentsDirectory()).path;
    unawaited(_scanAndExtractArchives());
  }

  /// 扫描文件夹中的所有压缩文件并解压
  Future<void> _scanAndExtractArchives() async {
    extractArchivesState.triggerQuery(
      query: () async {
        final folder = Directory(folderPath);
        if (!await folder.exists()) {
          throw Exception('文件夹不存在');
        }

        // 扫描所有压缩文件
        final files = await folder
            .list()
            .where((entity) => entity is File)
            .map((entity) => entity as File)
            .where((file) {
              final ext = p.extension(file.path).toLowerCase();
              return ['.zip', '.cbz'].contains(ext);
            })
            .toList();
        extractArchiveTotal.value = files.length;
        if (files.isEmpty) {
          throw Exception('未找到压缩文件');
        }

        // 逐个解压
        for (final file in files) {
          try {
            final archiveFolder = await _extractSingleArchive(file);
            archiveFolders.add(archiveFolder);
            extractArchiveProgress.value += 1;
          } catch (e) {
            debugPrint('解压失败: ${file.path}, 错误: $e');
          }
        }
        extractArchiveProgress.value = 0;
        extractArchiveTotal.value = 0;
      },
    );
  }

  /// 解压单个压缩文件
  Future<ArchiveFolder> _extractSingleArchive(File file) async {
    final bytes = await file.readAsBytes();
    final title = p.basenameWithoutExtension(file.path);
    final tmpDir = p.join(
      (await getTemporaryDirectory()).path,
      'batch_import',
      DateTime.now().microsecondsSinceEpoch.toString(),
    );

    // 在后台线程中解压
    final extractedFiles = await compute(
      _extractZipInBackground,
      _ExtractParams(bytes, tmpDir),
    );

    return ArchiveFolder(
      title: title,
      originalPath: file.path,
      extractedPath: tmpDir,
      files: extractedFiles.map((path) => ArchiveFile(path: path)).toList(),
    );
  }

  /// 静态方法，在 Isolate 中执行解压
  static List<String> _extractZipInBackground(_ExtractParams params) {
    final archive = ZipDecoder().decodeBytes(params.bytes);
    final extractedPaths = <String>[];

    for (final entry in archive) {
      if (entry.isFile) {
        final fileBytes = entry.readBytes();
        final filePath = p.join(params.tmpDir, entry.name);
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!);
        extractedPaths.add(filePath);
      }
    }

    // 按文件名排序
    extractedPaths.sort();
    return extractedPaths;
  }

  /// 编辑文件夹中的文件
  void editArchiveFolder(int index) {
    Get.toNamed(
      AppRoute.parseArchiveBatchEdit,
      arguments: archiveFolders[index],
    )?.then((updatedFolder) {
      if (updatedFolder != null && updatedFolder is ArchiveFolder) {
        archiveFolders[index] = updatedFolder;
      }
    });
  }

  /// 删除某个压缩包
  void removeArchiveFolder(int index) {
    archiveFolders.removeAt(index);
  }

  /// 保存所有书籍
  Future<void> saveAllBooks() async {
    saveAllBooksState.triggerEvent(
      event: () async {
        if (archiveFolders.isEmpty) throw Exception('没有可保存的书籍');

        for (final archiveFolder in archiveFolders) {
          // 将解压后的文件转为 File 列表
          final files = archiveFolder.files
              .map((f) => File(f.path))
              .where((f) => f.existsSync())
              .toList();

          if (files.isEmpty) continue;

          final group = await importService.buildImportGroup(
            name: archiveFolder.title,
            type: ImportType.zip,
            files: files,
          );
          importService.addImportGroup(group);
          // 不等待完成，直接加入队列后跳转
          unawaited(importService.startImport(group.id));
        }
      },
    );
  }
}

/// 压缩包文件夹模型
class ArchiveFolder {
  final String title;
  final String originalPath;
  final String extractedPath;
  final List<ArchiveFile> files;

  ArchiveFolder({
    required this.title,
    required this.originalPath,
    required this.extractedPath,
    required this.files,
  });

  ArchiveFolder copyWith({
    String? title,
    String? originalPath,
    String? extractedPath,
    List<ArchiveFile>? files,
  }) {
    return ArchiveFolder(
      title: title ?? this.title,
      originalPath: originalPath ?? this.originalPath,
      extractedPath: extractedPath ?? this.extractedPath,
      files: files ?? this.files,
    );
  }
}

/// 压缩包中的文件模型
class ArchiveFile {
  final String path;

  ArchiveFile({required this.path});
}

/// 用于传递参数到 compute
class _ExtractParams {
  final Uint8List bytes;
  final String tmpDir;

  _ExtractParams(this.bytes, this.tmpDir);
}
