import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_to_image_converter/pdf_to_image_converter.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/service/toast_service.dart';
import 'package:tele_book/app/util/pick_file_util.dart';
import 'package:tele_book/app/util/request_state.dart';

class BookFormController extends GetxController {
  final source = Rxn<BookFormSources>(null);
  final submitFormState = Rx<RequestState<void>>(Idle());
  final webUrlController = TextEditingController();
  final filePathController = TextEditingController();
  final folderPathController = TextEditingController();
  final pdfPathController = TextEditingController();
  final imageFolderPathController = TextEditingController();
  final batchImageFolderPathController = TextEditingController();

  Future<void> submitForm() async {
    final sourceValue = source.value;
    if (sourceValue?.value == null) {
      ToastService.showError("请选择书籍来源");
      return;
    }

    if (sourceValue == BookFormSources.web) {
      final url = webUrlController.text;
      if (url.toString().trim().isEmpty) {
        ToastService.showError("请输入网页地址");
        return;
      }
      // 然后打开解析页面
      Get.offAndToNamed(AppRoute.parseWeb, arguments: url.toString());
    }
    if (sourceValue == BookFormSources.archive) {
      final file = filePathController.text;
      if (file.toString().trim().isEmpty) {
        ToastService.showError("请选择压缩包文件");
        return;
      }
      Get.offAndToNamed(
        AppRoute.parseArchiveSingle,
        arguments: file.toString(),
      );
    }
    if (sourceValue == BookFormSources.batchArchive) {
      final folder = folderPathController.text;
      if (folder.toString().trim().isEmpty) {
        ToastService.showError("请选择压缩包文件夹");
        return;
      }
      Get.offAndToNamed(
        AppRoute.parseArchiveBatch,
        arguments: folder.toString(),
      );
    }
    if (sourceValue == BookFormSources.pdf) {
      final pdf = pdfPathController.text;
      if (pdf.toString().trim().isEmpty) {
        ToastService.showError("请选择PDF文件");
        return;
      }
      Get.offAndToNamed(AppRoute.parsePdf, arguments: {'path': pdf.toString()});
    }
    if (sourceValue == BookFormSources.imageFolder) {
      final folder = imageFolderPathController.text;
      if (folder.toString().trim().isEmpty) {
        ToastService.showError("请选择图片文件夹");
        return;
      }
      Get.offAndToNamed(
        AppRoute.parseImageFolder,
        arguments: folder.toString(),
      );
    }
    if (sourceValue == BookFormSources.batchImageFolder) {
      final folder = batchImageFolderPathController.text;
      if (folder.toString().trim().isEmpty) {
        ToastService.showError("请选择包含图片文件夹的父文件夹");
        return;
      }
      Get.offAndToNamed(
        AppRoute.parseBatchImageFolder,
        arguments: folder.toString(),
      );
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
