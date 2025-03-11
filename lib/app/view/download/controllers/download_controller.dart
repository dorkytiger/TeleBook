import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wo_nas/app/db/app_database.dart';
import 'package:wo_nas/app/model/dto/book_dto.dart';
import 'package:wo_nas/app/model/dto/book_picture_dto.dart';
import 'package:wo_nas/app/model/entity/download/download_state_entity.dart';

class DownloadController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();
  TextEditingController urlController = TextEditingController();
  final RxList<DownloadState> downloadStates = <DownloadState>[].obs;

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
    final imageResponse = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes),
            onReceiveProgress: (current, total) {
      downloadStates[index].proImg = (current / total).toDouble();
      downloadStates.refresh();
    });
    final saveFile = File(filePath);
    if (imageResponse.data != null) {
      await saveFile.writeAsBytes(imageResponse.data);
    }
    downloadStates[index].progress = (count / imagesSize).toDouble();
    downloadStates[index].page = count;
    downloadStates.refresh();
  }

  void downloadBook(int index, String url) async {
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

      final response = await GetConnect().get(url);
      if (response.hasError) {
        throw Exception("连接失败：${response.statusText}");
      }

      final htmlString = await response.body;
      final document = parse(htmlString);
      final title = document.querySelector("h1")?.text;

      if (title == null) {
        downloadStates[index].state = 0;
        downloadStates.refresh();
        throw Exception("文本解析失败");
      }

      final tmpFile = await getApplicationDocumentsDirectory();
      debugPrint(tmpFile.path);
      final tmpBooksPath = "${tmpFile.path}/book";
      await createDirectoryIfNotExists(tmpBooksPath);

      final bookPath = "$tmpBooksPath/$title";
      await createDirectoryIfNotExists(bookPath);

      final images = document.querySelectorAll("img");
      final imagesSize = images.length;
      downloadStates[index].pageSize = imagesSize;
      downloadStates.refresh();

      List<String> localFilePath=[];
      List<String> imageUrls=[];

      for (var count = 0; count < images.length; count++) {
        final imageUrl = images[count].attributes["src"];
        if (imageUrl == null) {
          throw Exception("图片解析失败");
        }
        final filePath = "$bookPath/image_$count.png";
        await saveImage(imageUrl, filePath, index, count + 1, imagesSize);

        localFilePath.add(filePath);
        imageUrls.add(filePath);

        if (count == 0) {
          downloadStates[index].preview = filePath;
          downloadStates.refresh();
        }
      }
      await appDatabase
          .into(appDatabase.bookTable).insert(BookTableCompanion.insert(name: title, localPaths: localFilePath, imageUrls: imageUrls));

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
