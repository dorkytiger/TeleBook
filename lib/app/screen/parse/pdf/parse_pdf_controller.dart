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

  DKStateQuery<int> initState = DkStateQueryIdle();
  bool isImporting = false;

  final List<Uint8List?> pageImages = [];
  final List<bool> pageLoading = [];

  Future<void> _renderQueue = Future.value();

  int get totalPages => pageImages.length;

  ParsePdfController({required this.path, required this.importStore}) {
    _openPdf();
  }

  @override
  void dispose() {
    _converter.closePdf();
    super.dispose();
  }

  Future<void> _openPdf() async {
    await DKStateQueryHelper.triggerQuery(
      onStateChange: (value) {
        initState = value;
        notifyListeners();
      },
      query: () async {
        await _converter.openPdf(path);
        final count = _converter.pageCount;
        pageImages.clear();
        pageImages.addAll(List<Uint8List?>.filled(count, null));
        pageLoading.clear();
        pageLoading.addAll(List<bool>.filled(count, false));
        return count;
      },
    );
  }

  Future<void> renderPage(int index) async {
    if (index < 0 || index >= totalPages) return;
    if (pageImages[index] != null || pageLoading[index]) return;

    pageLoading[index] = true;
    notifyListeners();

    _renderQueue = _renderQueue.then((_) => _doRender(index));
    await _renderQueue;
  }

  Future<void> _doRender(int index) async {
    if (index < 0 || index >= totalPages) return;
    if (pageImages[index] != null) {
      pageLoading[index] = false;
      notifyListeners();
      return;
    }
    try {
      final image = await _converter.renderPage(index);
      pageImages[index] = image;
    } catch (e) {
      debugPrint('渲染第 ${index + 1} 页失败: $e');
    } finally {
      if (index < pageLoading.length) {
        pageLoading[index] = false;
      }
      notifyListeners();
    }
  }

  void releasePage(int index) {
    if (index < 0 || index >= totalPages) return;
    if (pageImages[index] == null) return;
    pageImages[index] = null;
    notifyListeners();
  }

  Future<void> importPDF() async {
    if (isImporting) return;
    isImporting = true;
    notifyListeners();

    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final name = p.basenameWithoutExtension(path);

      final group = ImportGroup(id: id, name: name, type: ImportType.pdf);

      final tempDir = await getTemporaryDirectory();
      final pdfTempDir = Directory('${tempDir.path}/pdf_$id');
      if (!await pdfTempDir.exists()) {
        await pdfTempDir.create(recursive: true);
      }

      for (var i = 0; i < totalPages; i++) {
        Uint8List? imageData = pageImages[i];
        bool rendered = false;
        if (imageData == null) {
          imageData = await _converter.renderPage(i);
          rendered = true;
        }
        if (imageData == null) continue;

        final tempFile = File('${pdfTempDir.path}/page_${i + 1}.png');
        await tempFile.writeAsBytes(imageData);

        if (rendered) imageData = null;

        group.tasks.value = [
          ...group.tasks.value,
          ImportTask(id: '${id}_task_$i', groupId: id, filePath: tempFile.path),
        ];
      }

      importStore.addImportGroup(group);
      await importStore.startImport(group);

      if (await pdfTempDir.exists()) {
        await pdfTempDir.delete(recursive: true);
      }
    } finally {
      isImporting = false;
      notifyListeners();
    }
  }
}
