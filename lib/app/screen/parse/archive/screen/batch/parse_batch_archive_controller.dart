import 'dart:async';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_query_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/store/import_store.dart';

class ParseBatchArchiveController extends ChangeNotifier {
  final String folderPath;
  final ImportStore importStore;

  DKStateQuery<void> extractArchivesState = DkStateQueryIdle();
  int extractArchiveProgress = 0;
  int extractArchiveTotal = 0;
  List<ArchiveFolder> archiveFolders = [];

  ParseBatchArchiveController({
    required this.folderPath,
    required this.importStore,
  }) {
    unawaited(_scanAndExtractArchives());
  }

  Future<void> _scanAndExtractArchives() async {
    await DKStateQueryHelper.triggerQuery(
      onStateChange: (value) {
        extractArchivesState = value;
        notifyListeners();
      },
      query: () async {
        final folder = Directory(folderPath);
        if (!await folder.exists()) throw Exception('文件夹不存在');

        final files = await folder
            .list()
            .where((e) => e is File)
            .cast<File>()
            .where((f) => ['.zip', '.cbz'].contains(
                p.extension(f.path).toLowerCase()))
            .toList();

        extractArchiveTotal = files.length;
        notifyListeners();
        if (files.isEmpty) throw Exception('未找到压缩文件');

        for (final file in files) {
          try {
            final archiveFolder = await _extractSingleArchive(file);
            archiveFolders.add(archiveFolder);
            extractArchiveProgress++;
            notifyListeners();
          } catch (e) {
            debugPrint('解压失败: ${file.path}, 错误: $e');
          }
        }
        extractArchiveProgress = 0;
        extractArchiveTotal = 0;
      },
    );
  }

  Future<ArchiveFolder> _extractSingleArchive(File file) async {
    final bytes = await file.readAsBytes();
    final title = p.basenameWithoutExtension(file.path);
    final tmpDir = p.join(
      (await getTemporaryDirectory()).path,
      'batch_import',
      DateTime.now().microsecondsSinceEpoch.toString(),
    );
    final extractedFiles = await compute(
        _extractZipInBackground, _ExtractParams(bytes, tmpDir));
    return ArchiveFolder(
      title: title,
      originalPath: file.path,
      extractedPath: tmpDir,
      files: extractedFiles.map((path) => ArchiveFile(path: path)).toList(),
    );
  }

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
    extractedPaths.sort();
    return extractedPaths;
  }

  /// 返回需要 context.push 的路由结果；由 Screen 处理导航
  void updateArchiveFolder(int index, ArchiveFolder updatedFolder) {
    archiveFolders[index] = updatedFolder;
    notifyListeners();
  }

  Future<void> saveAllBooks() async {
    if (archiveFolders.isEmpty) throw Exception('没有可保存的书籍');
    for (final archiveFolder in archiveFolders) {
      final files = archiveFolder.files
          .map((f) => File(f.path))
          .where((f) => f.existsSync())
          .toList();
      if (files.isEmpty) continue;

      final group = await importStore.buildImportGroup(
        name: archiveFolder.title,
        type: ImportType.zip,
        files: files,
      );
      importStore.addImportGroup(group);
      await importStore.startImport(group);
    }
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
