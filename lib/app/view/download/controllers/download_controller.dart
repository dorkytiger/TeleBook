import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wo_nas/app/model/dto/book_dto.dart';
import 'package:wo_nas/app/model/dto/book_picture_dto.dart';
import 'package:wo_nas/app/service/book_service.dart';

import '../../../model/entity/download/download_state_entity.dart';

class DownloadController extends GetxController {
  TextEditingController urlController = TextEditingController();
  RxList<DownloadState> downloadStates = <DownloadState>[].obs;

  late final _bookService = BookService();

  void updateDownloadState(int index, DownloadState newState) {
    if (downloadStates.length <= index) {
      downloadStates.insert(index, newState);
      downloadStates.refresh();
    } else {
      downloadStates[index] = newState;
      downloadStates.refresh();
    }
  }

  Future<void> createDirectoryIfNotExists(String path) async {
    final directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync();
    }
  }

  Future<void> saveImage(
      String url, String filePath, int index, int count, int imagesSize) async {
    var imageResponse = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes),
            onReceiveProgress: (current, total) {
      downloadStates[index].proImg = (current / total).toDouble();
      downloadStates.refresh();
    });
    var saveFile = File(filePath);
    if (imageResponse.data != null) {
      saveFile.writeAsBytes(imageResponse.data);
    }
    downloadStates[index].progress = (count / imagesSize).toDouble();
    downloadStates[index].page = count;
    downloadStates.refresh();
  }

  void getBook(int index, String url) async {
    try {
      updateDownloadState(
          index,
          DownloadState(
            link: url,
            progress: 0.0,
            proImg: 0.0,
            preview: '',
            pageSize: 0,
            page: 0,
            state: 1,
          ));

      var response = await GetConnect().get(url);
      if (response.hasError) {
        throw Exception("连接失败");
      }

      final htmlString = response.body;
      final document = parse(htmlString);
      final title = document.querySelector("h1");
      if (title == null) {
        downloadStates[index].state = 0;
        downloadStates.refresh();
        throw Exception("文本解析失败");
      }

      final tmpFile = await getApplicationDocumentsDirectory();
      final tmpBooksPath = "${tmpFile.path}/book";
      await createDirectoryIfNotExists(tmpBooksPath);

      final bookPath = "$tmpBooksPath/${title.text}";
      await createDirectoryIfNotExists(bookPath);

      final images = document.querySelectorAll("img");
      final imagesSize = images.length;
      downloadStates[index].pageSize = imagesSize;
      downloadStates.refresh();

      final bookId = await _bookService
          .addBook(BookDTO(title: title.text, path: bookPath));
      if (bookId == null) {
        throw ArgumentError("插入失败");
      }

      for (var count = 0; count < images.length; count++) {
        var imageUrl = "https://telegra.ph${images[count].attributes['src']}";
        var filePath = "$bookPath/image_$count.png";
        await saveImage(imageUrl, filePath, index, count + 1, imagesSize);

        if (count == 0) {
          downloadStates[index].preview = filePath;
          downloadStates.refresh();
        }
        await _bookService.addBookPicture(
            BookPictureDto(bookId: bookId, path: filePath, number: count + 1));
      }

      downloadStates[index].state = 2;
      downloadStates.refresh();
      if (checkIsClean()) {
        cleanDown(index);
      }
    } catch (e) {
      Get.snackbar('下载发生错误', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  cleanDown(int index) {
    downloadStates.clear();
    downloadStates.refresh();
  }

  deleteDown(int index) {
    downloadStates.removeAt(index);
    downloadStates.refresh();
  }

  checkIsClean() {
    if (downloadStates.isEmpty) {
      return false;
    }
    for (var state in downloadStates) {
      if (state.state != 2) {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    downloadStates.clear();
    downloadStates.refresh();
    super.dispose();
  }
}
