import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/export/enum/export_format.dart';
import 'package:tele_book/feature/export/model/export_item.dart';
import 'package:tele_book/feature/export/service/export_service.dart';

class ExportBatchViewmodel extends ChangeNotifier {
  final ExportService _exportService = ExportService();

  ExportFormat format = ExportFormat.folder;
  String? outputPath;
  late final List<ExportItem> items;

  bool isExporting = false;
  bool isDone = false;
  int progress = 0;
  String? errorMessage;

  ExportBatchViewmodel({required List<BookTableData> books}) {
    items = books.map((b) => ExportItem(book: b)).toList();
  }

  void setFormat(ExportFormat fmt) {
    format = fmt;
    notifyListeners();
  }

  Future<void> pickOutputDir() async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      outputPath = result;
      notifyListeners();
    }
  }

  Future<void> export() async {
    final path = outputPath;
    if (path == null) {
      errorMessage = '请选择导出路径';
      notifyListeners();
      return;
    }

    // 验证所有文件名不为空
    for (final item in items) {
      if (item.nameController.text.trim().isEmpty) {
        errorMessage = '导出项"${item.book.name}"的文件名不能为空';
        notifyListeners();
        return;
      }
    }

    isExporting = true;
    progress = 0;
    errorMessage = null;
    notifyListeners();

    try {
      final exportList = items
          .map((i) => (book: i.book, fileName: i.nameController.text.trim()))
          .toList();

      await _exportService.exportBatch(
        items: exportList,
        outputDirPath: path,
        format: format,
        onProgress: (current, total) {
          progress = current;
          notifyListeners();
        },
      );
      isDone = true;
    } catch (e) {
      errorMessage = '导出失败：$e';
    } finally {
      isExporting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    for (final item in items) {
      item.dispose();
    }
    super.dispose();
  }
}

