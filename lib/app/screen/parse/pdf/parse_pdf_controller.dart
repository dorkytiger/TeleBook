import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart' hide Value;
import 'package:pdf_to_image_converter/pdf_to_image_converter.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:drift/drift.dart';

class ParsePdfController extends GetxController {
  final path = Get.arguments['path'] as String;
  final PdfImageConverter _converter = PdfImageConverter();
  final images = Rxn<List<Uint8List?>>();
  final renderPageState = Rx<RequestState<List<Uint8List?>>>(Idle());
  final saveToLocalState = Rx<RequestState<void>>(Idle());

  // database reference
  final appDatabase = Get.find<AppDatabase>();

  @override
  void onInit() {
    super.onInit();
    renderPDF();
    saveToLocalState.listenWithSuccess(
      onSuccess: () {
        final booksController = Get.find<BookController>();
        booksController.fetchBooks();
        Get.back();
      },
    );
  }

  Future<void> renderPDF() async {
    try {
      renderPageState.value = Loading();
      await _converter.openPdf(path);
      images.value = await _converter.renderAllPages();
      debugPrint("解析完成");

      renderPageState.value = Success(images.value!);
    } catch (e) {
      renderPageState.value = Error('转换PDF为图片时出错: $e');
      print('Error converting PDF to images: $e');
    }
  }

  Future<void> saveImagesToLocal() async {
    try {
      saveToLocalState.value = Loading();
      if (images.value == null || images.value!.isEmpty) {
        throw Exception("没有可保存的图片");
      }

      final title = p.basenameWithoutExtension(path);
      final groupPath = "$title-${DateTime.now().microsecondsSinceEpoch}";
      final appDocDir = await getApplicationDocumentsDirectory();
      final saveDir = p.join(appDocDir.path, groupPath);

      final localPaths = <String>[];
      int index = 1;

      for (final imageData in images.value!) {
        if (imageData == null) {
          index++;
          continue;
        }

        // 文件名格式：00000001.jpg
        final fileName = "${index.toString().padLeft(8, '0')}.jpg";
        final savePath = p.join(saveDir, fileName);

        final file = File(savePath);
        await file.parent.create(recursive: true);
        await file.writeAsBytes(imageData);

        localPaths.add(p.join(groupPath, fileName));
        index++;
      }

      if (localPaths.isEmpty) {
        throw Exception('没有可保存的有效图片');
      }

      await appDatabase.bookTable.insertOnConflictUpdate(
        BookTableCompanion(name: Value(title), localPaths: Value(localPaths)),
      );

      saveToLocalState.value = Success(null);
    } catch (e) {
      saveToLocalState.value = Error('保存图片时出错: $e');
      print('Error saving images to local: $e');
    }
  }
}
