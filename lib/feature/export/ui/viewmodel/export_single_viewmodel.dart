import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/export/enum/export_format.dart';
import 'package:tele_book/feature/export/service/export_service.dart';

class ExportSingleViewmodel extends ChangeNotifier {
  final BookTableData book;
  final ExportService _exportService = ExportService();

  ExportFormat format = ExportFormat.folder;
  String? outputPath;
  late final TextEditingController fileNameController;

  bool isExporting = false;
  bool isDone = false;
  String? errorMessage;

  ExportSingleViewmodel({required this.book}) {
    fileNameController = TextEditingController(text: book.name);
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
    final name = fileNameController.text.trim();
    if (name.isEmpty) {
      errorMessage = '请输入导出文件名';
      notifyListeners();
      return;
    }

    isExporting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _exportService.exportSingle(
        book: book,
        outputDirPath: path,
        fileName: name,
        format: format,
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
    fileNameController.dispose();
    super.dispose();
  }
}

