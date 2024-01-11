import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DownloadController extends GetxController {
  TextEditingController urlController = TextEditingController();
  RxList<String> currentDownLink = <String>[].obs;
  RxList<double> currentDownProgress = <double>[].obs;
  RxList<double> currentDownProImg = <double>[].obs;
  RxList<String> currentDownPreview = <String>[].obs;
  RxList<int> currentDownPageSize = <int>[].obs;
  RxList<int> currentDownPage = <int>[].obs;
  RxList<int> connectState = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  insertList(List<dynamic> list, int index, dynamic element) {
    if (list.isEmpty) {
      list.add(element);
      update();
    } else if (list.isNotEmpty && list.length <= index) {
      list.insert(index, element);
      update();
    } else {
      list[index] = element;
      update();
    }
  }

  getBook(int index, String url) async {
    try {
      insertList(connectState, index, 1);
      insertList(currentDownLink, index, url);
      var response = await GetConnect().get(url);
      if (response.hasError) {
        throw Exception("连接失败");
      }
      final htmlString = response.body;
      insertList(currentDownProgress, index, 0.0);
      insertList(currentDownPage, index, 0);
      final document = parse(htmlString);
      final title = document.querySelector("h1");
      if (title == null) {
        insertList(connectState, index, 0);
        throw Exception("文本解析失败");
      }
      final tmpFile = await getApplicationDocumentsDirectory();
      final tmpBooks = Directory("${tmpFile.path}/book");
      if (!tmpBooks.existsSync()) {
        tmpBooks.createSync();
      }
      final tmpDirectory = Directory("${tmpFile.path}/book/${title.text}");
      tmpDirectory.createSync();
      final images = document.querySelectorAll("img");
      final imagesSize = images.length;
      insertList(currentDownPageSize, index, imagesSize);
      var count = 0;
      for (var element in images) {
        var url = "https://telegra.ph${element.attributes['src']}";
        var imageResponse = await Dio().get(url,
            options: Options(
              responseType: ResponseType.bytes,
            ), onReceiveProgress: (current, total) {
          insertList(currentDownProImg, index, (current / total).toDouble());
        });
        var saveFile = File("${tmpDirectory.path}/image_$count.png");
        if (imageResponse.data != null) {
          saveFile.writeAsBytes(imageResponse.data);
        }
        if (count == 0) {
          insertList(currentDownPreview, index,
              "${tmpDirectory.path}/image_$count.png");
        }
        count++;
        insertList(currentDownProgress, index, (count / imagesSize).toDouble());
        insertList(currentDownPage, index, count);
        update();

      }
      connectState[index]=2;
      if (checkIsClean()) {
        cleanDown(index);
      }
      update();
    } catch (e) {
      connectState.insert(index, 0);
      print(e);
    }
  }

  cleanDown(int index) {
    currentDownLink.removeRange(0, currentDownLink.length);
    currentDownProgress.removeRange(0, currentDownProgress.length);
    currentDownPageSize.removeRange(0, currentDownPage.length);
    currentDownPage.removeRange(0, currentDownPage.length);
    currentDownProImg.removeRange(0, currentDownProImg.length);
    currentDownPreview.removeRange(0, currentDownPreview.length);
    connectState.removeRange(0, connectState.length);
  }

  deleteDown(int index) {
    currentDownLink.removeAt(index);
    currentDownProgress.removeAt(index);
    currentDownPreview.removeAt(index);
    currentDownPage.removeAt(index);
    currentDownPageSize.removeAt(index);
    currentDownProImg.removeAt(index);
    connectState.removeAt(index);
  }

  checkIsClean() {
    if (currentDownProgress.isEmpty) {
      return false;
    }
    for (int connect in connectState) {
      if (connect != 2) {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    currentDownProgress.value = [];
    currentDownLink.value = [];
    currentDownPreview.value = [];
    currentDownPage.value = [];
    currentDownPageSize.value = [];
    currentDownProImg.value = [];
    connectState.value = [];
    super.dispose();
  }
}
