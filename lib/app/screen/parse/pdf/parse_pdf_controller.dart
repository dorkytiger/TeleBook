import 'dart:async';
import 'dart:typed_data';
import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_query_helper.dart';
import 'package:flutter/material.dart';
import 'package:pdf_to_image_converter/pdf_to_image_converter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/store/import_store.dart';

class ParsePdfController extends ChangeNotifier {
  final String path;
  final ImportStore importStore;

  final PdfImageConverter _converter = PdfImageConverter();

  /// 处理进度状态，成功后 data 为临时图片文件列表
  DKStateQuery<List<File>> processState = DkStateQueryIdle();

  /// 渲染进度
  int processedCount = 0;
  int totalPages = 0;

  /// 临时目录，dispose 时清理
  Directory? _tempDir;

  String get bookName => p.basenameWithoutExtension(path);

  ParsePdfController({required this.path, required this.importStore}) {
    _processAllPages();
  }

  @override
  void dispose() {
    _converter.closePdf();
    _cleanTempDir();
    super.dispose();
  }

  void _cleanTempDir() {
    final dir = _tempDir;
    if (dir != null && dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }

  Future<void> _processAllPages() async {
    await DKStateQueryHelper.triggerQuery(
      onStateChange: (value) {
        processState = value;
        notifyListeners();
      },
      query: () async {
        await _converter.openPdf(path);
        totalPages = _converter.pageCount;
        notifyListeners();

        final tempBase = await getTemporaryDirectory();
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        _tempDir = Directory('${tempBase.path}/pdf_preview_$id');
        await _tempDir!.create(recursive: true);

        final List<File> pageFiles = [];
        for (var i = 0; i < totalPages; i++) {
          final Uint8List? imageData = await _converter.renderPage(i);
          if (imageData == null) continue;
          final file = File(
            '${_tempDir!.path}/page_${(i + 1).toString().padLeft(4, '0')}.png',
          );
          await file.writeAsBytes(imageData);
          pageFiles.add(file);
          processedCount = i + 1;
          notifyListeners();
        }
        return pageFiles;
      },
    );
  }

  Future<void> importPDF() async {
    final state = processState;
    if (state is! DkStateQuerySuccess<List<File>>) return;
    final pageFiles = state.data;
    if (pageFiles.isEmpty) return;

    final group = await importStore.buildImportGroup(
      name: bookName,
      type: ImportType.pdf,
      files: pageFiles,
    );
    importStore.addImportGroup(group);
    unawaited(importStore.startImport(group));
  }
}
