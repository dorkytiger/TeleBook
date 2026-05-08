import 'dart:io';

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
  List<String> batchArchivePaths = [];
  final TextEditingController imageFolderPathController =
      TextEditingController();
  List<String> imagePaths = [];
  final TextEditingController batchImageFolderPathController =
      TextEditingController();
  List<String> batchImagePaths = [];
  final TextEditingController pdfPathController = TextEditingController();
  final TextEditingController batchPdfPathController = TextEditingController();
  List<String> batchPdfPaths = [];

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
          extra: batchArchivePaths.isNotEmpty
              ? batchArchivePaths
              : batchArchivePathController.text,
        );
        break;
      case ParseFormType.imageFolder:
        context.push(
          AppRoute.parseImageFolder,
          extra: imagePaths.isNotEmpty
              ? imagePaths
              : imageFolderPathController.text,
        );
        break;
      case ParseFormType.batchImageFolder:
        context.push(
          AppRoute.parseBatchImageFolder,
          extra: batchImagePaths.isNotEmpty
              ? batchImagePaths
              : batchImageFolderPathController.text,
        );
        break;
      case ParseFormType.pdf:
        context.push(AppRoute.parsePdf, extra: pdfPathController.text);
        break;
      case ParseFormType.batchPdf:
        context.push(
          AppRoute.parseBatchPdf,
          extra: batchPdfPaths.isNotEmpty
              ? batchPdfPaths
              : batchPdfPathController.text,
        );
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
    if (Platform.isIOS) {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: "选择一个或多个 ZIP 压缩包",
        type: FileType.custom,
        allowedExtensions: ['zip'],
        allowMultiple: true,
      );
      if (result != null) {
        final paths = result.paths.whereType<String>().toList();
        batchArchivePaths = paths;
        batchArchivePathController.text = paths.isEmpty
            ? ''
            : '已选择 ${paths.length} 个 ZIP 文件';
        notifyListeners();
      }
      return;
    }

    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "选择 TeleBook 导出的书籍归档文件夹",
    );
    if (result != null) {
      batchArchivePaths = [];
      batchArchivePathController.text = result;
      notifyListeners();
    }
  }

  Future<void> pickerImageFolder(BuildContext context) async {
    if (Platform.isIOS) {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: "选择图片文件",
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'],
        allowMultiple: true,
      );
      if (result != null) {
        final paths = result.paths.whereType<String>().toList();
        imagePaths = paths;
        imageFolderPathController.text = paths.isEmpty
            ? ''
            : '已选择 ${paths.length} 张图片';
        notifyListeners();
      }
      return;
    }

    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "选择包含图片的文件夹",
    );
    if (result != null) {
      imagePaths = [];
      imageFolderPathController.text = result;
      notifyListeners();
    }
  }

  Future<void> pickerBatchImageFolder(BuildContext context) async {
    if (Platform.isIOS) {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: "选择批量图片文件",
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'],
        allowMultiple: true,
      );
      if (result != null) {
        final paths = result.paths.whereType<String>().toList();
        batchImagePaths = paths;
        batchImageFolderPathController.text = paths.isEmpty
            ? ''
            : '已选择 ${paths.length} 张图片（按所在文件夹分组）';
        notifyListeners();
      }
      return;
    }

    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "选择批量图片文件夹的父目录",
    );
    if (result != null) {
      batchImagePaths = [];
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
    if (Platform.isIOS) {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: "选择一个或多个 PDF 文件",
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );
      if (result != null) {
        final paths = result.paths.whereType<String>().toList();
        batchPdfPaths = paths;
        batchPdfPathController.text = paths.isEmpty
            ? ''
            : '已选择 ${paths.length} 个 PDF 文件';
        notifyListeners();
      }
      return;
    }

    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "选择包含 PDF 的文件夹",
    );
    if (result != null) {
      batchPdfPaths = [];
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
