import 'package:dk_util/dk_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_to_image_converter/pdf_to_image_converter.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/util/pick_file_util.dart';

class ParseFormController extends ChangeNotifier {
  BookFormSources source = BookFormSources.web;
  DKStateEvent<void> submitFormState = DKStateEventIdle();
  final sourceController = TextEditingController();
  final webUrlController = TextEditingController();
  final filePathController = TextEditingController();
  final folderPathController = TextEditingController();
  final pdfPathController = TextEditingController();
  final imageFolderPathController = TextEditingController();
  final batchImageFolderPathController = TextEditingController();

  Future<void> submitForm(BuildContext context) async {
    final sourceValue = source;

    if (sourceValue == BookFormSources.web) {
      final url = webUrlController.text;
      if (url.toString().trim().isEmpty) {
        return;
      }
      // 然后打开解析页面
      context.pushNamed(
        AppRoute.parseWeb,
        pathParameters: {"url": url.toString()},
      );
    }
    if (sourceValue == BookFormSources.archive) {
      final file = filePathController.text;
      if (file.toString().trim().isEmpty) {
        return;
      }
      context.pushNamed(
        AppRoute.parseArchiveSingle,
        pathParameters: {"file": file.toString()},
      );
    }
    if (sourceValue == BookFormSources.batchArchive) {
      final folder = folderPathController.text;
      if (folder.toString().trim().isEmpty) {
        return;
      }
      context.pushNamed(
        AppRoute.parseArchiveBatch,
        pathParameters: {"folder": folder.toString()},
      );
    }
    if (sourceValue == BookFormSources.pdf) {
      final pdf = pdfPathController.text;
      if (pdf.toString().trim().isEmpty) {
        return;
      }
      context.pushNamed(
        AppRoute.parsePdf,
        pathParameters: {"path": pdf.toString()},
      );
    }
    if (sourceValue == BookFormSources.imageFolder) {
      final folder = imageFolderPathController.text;
      if (folder.toString().trim().isEmpty) {
        return;
      }
      context.pushNamed(
        AppRoute.parseImageFolder,
        pathParameters: {"folder": folder.toString()},
      );
    }
    if (sourceValue == BookFormSources.batchImageFolder) {
      final folder = batchImageFolderPathController.text;
      if (folder.toString().trim().isEmpty) {
        return;
      }
      context.pushNamed(
        AppRoute.parseBatchImageFolder,
        pathParameters: {"folder": folder.toString()},
      );
    }
  }

  Future<void> pasteFromClipboard(BuildContext context) async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null &&
        clipboardData.text != null &&
        clipboardData.text!.trim().isNotEmpty) {
      webUrlController.text = clipboardData.text!.trim();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("剪贴板中没有有效的文本")));
    }
  }

  Future<void> pickArchiveFile() async {
    final result = await PickFileUtil.pickerFile(
      type: FileType.custom,
      allowedExtensions: ['zip', 'rar', '7z', 'cbz', 'cbr'],
    );
    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.first.path;
      if (filePath != null) {
        filePathController.text = filePath;
      }
    }
  }

  Future<void> pickFolder() async {
    final folderPath = await PickFileUtil.pickDirectory();
    if (folderPath != null) {
      folderPathController.text = folderPath;
    }
  }

  Future<void> pickPdf() async {
    final path = await PdfPicker.pickPdf();
    if (path != null) {
      pdfPathController.text = path;
    }
  }

  Future<void> pickImageFolder() async {
    final folderPath = await PickFileUtil.pickDirectory();
    if (folderPath != null) {
      imageFolderPathController.text = folderPath;
    }
  }

  Future<void> pickBatchImageFolder() async {
    final folderPath = await PickFileUtil.pickDirectory();
    if (folderPath != null) {
      batchImageFolderPathController.text = folderPath;
    }
  }
}

enum BookFormSources {
  web("web", "网页"),
  archive("archive", "压缩包"),
  batchArchive("batch_archive", "批量压缩包"),
  pdf("pdf", "PDF"),
  imageFolder("image_folder", "文件夹图片"),
  batchImageFolder("batch_image_folder", "批量文件夹图片");

  final String value;
  final String desc;

  const BookFormSources(this.value, this.desc);
}
