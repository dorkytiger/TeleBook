import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/route/app_route.dart';

class ParseFormViewmodel extends ChangeNotifier {
  ParseFormType type = ParseFormType.web;
  final TextEditingController urlController = TextEditingController();
  final TextEditingController archivePathController = TextEditingController();
  final TextEditingController batchArchivePathController =
      TextEditingController();
  final TextEditingController imageFolderPathController =
      TextEditingController();
  final TextEditingController batchImageFolderPathController =
      TextEditingController();
  final TextEditingController pdfPathController = TextEditingController();
  final TextEditingController batchPdfPathController = TextEditingController();

  void setType(ParseFormType? newType) {
    if (newType != null) {
      type = newType;
      notifyListeners();
    }
  }

  void onParse(BuildContext context) {
    switch (type) {
      case ParseFormType.web:
        context.push(AppRoute.parseWeb, extra: urlController.text);
        break;
      case ParseFormType.archive:
        context.push(
          AppRoute.parseArchiveSingle,
          extra: archivePathController.text,
        );
        break;
      case ParseFormType.batchArchive:
        context.push(
          AppRoute.parseArchiveBatch,
          extra: batchArchivePathController.text,
        );
        break;
      case ParseFormType.imageFolder:
        context.push(
          AppRoute.parseImageFolder,
          extra: imageFolderPathController.text,
        );
        break;
      case ParseFormType.batchImageFolder:
        context.push(
          AppRoute.parseBatchImageFolder,
          extra: batchImageFolderPathController.text,
        );
        break;
      case ParseFormType.pdf:
        context.push(AppRoute.parsePdf, extra: pdfPathController.text);
        break;
      case ParseFormType.batchPdf:
        context.push(AppRoute.parseBatchPdf, extra: batchPdfPathController.text);
        break;
    }
  }

  Future<void> getClipboardUrl() async {
    final clipboardData = await Clipboard.getData('text/plain');
    final text = clipboardData?.text ?? '';
    if (Uri.tryParse(text)?.hasAbsolutePath == true) {
      urlController.text = text;
      notifyListeners();
    }
  }

  Future<void> pickerArchive(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: "选择 TeleBook 导出的书籍归档文件",
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      archivePathController.text = path;
      notifyListeners();
    }
  }

  Future<void> pickerBatchArchive(BuildContext context) async {
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "选择 TeleBook 导出的书籍归档文件夹",
    );
    if (result != null) {
      batchArchivePathController.text = result;
      notifyListeners();
    }
  }

  Future<void> pickerImageFolder(BuildContext context) async {
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "选择包含图片的文件夹",
    );
    if (result != null) {
      imageFolderPathController.text = result;
      notifyListeners();
    }
  }

  Future<void> pickerBatchImageFolder(BuildContext context) async {
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "选择批量图片文件夹的父目录",
    );
    if (result != null) {
      batchImageFolderPathController.text = result;
      notifyListeners();
    }
  }

  Future<void> pickerPdf(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: "选择 PDF 文件",
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      pdfPathController.text = result.files.single.path!;
      notifyListeners();
    }
  }

  Future<void> pickerBatchPdf(BuildContext context) async {
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "选择包含 PDF 的文件夹",
    );
    if (result != null) {
      batchPdfPathController.text = result;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    urlController.dispose();
    archivePathController.dispose();
    batchArchivePathController.dispose();
    imageFolderPathController.dispose();
    batchImageFolderPathController.dispose();
    pdfPathController.dispose();
    batchPdfPathController.dispose();
    super.dispose();
  }
}

enum ParseFormType {
  web,
  archive,
  batchArchive,
  imageFolder,
  batchImageFolder,
  pdf,
  batchPdf,
}
