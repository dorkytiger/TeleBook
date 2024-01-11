import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';

class DownloadController extends GetxController {
  TextEditingController urlController = TextEditingController();
  RxList<String> currentDownLink = <String>[].obs;
  RxList<double> currentDownProgress = <double>[].obs;
  RxList<double> currentDownProImg=<double>[].obs;
  RxList<String> currentDownPreview = <String>[].obs;
  RxList<int> currentDownPageSize = <int>[].obs;
  RxList<int> currentDownPage = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  getBook(int index) async {
    String url = urlController.text;
    currentDownLink.insert(index, url);
    currentDownProgress.insert(index, 0);
    currentDownPage.insert(index, 0);
    var response = await GetConnect().get(url);
    var htmlString = await response.body;
    var document = parse(htmlString);
    final title = document.querySelector("h1");
    final tmpFile = await getApplicationDocumentsDirectory();
    final tmpBooks = Directory("${tmpFile.path}/book");
    if (!tmpBooks.existsSync()) {
      tmpBooks.createSync();
    }
    final tmpDirectory = Directory("${tmpFile.path}/book/${title?.text}");
    tmpDirectory.createSync();
    final images = document.querySelectorAll("img");
    final imagesSize = images.length;
    currentDownPageSize.insert(index, imagesSize);
    var count = 0;
    for (var element in images) {
      var url = "https://telegra.ph${element.attributes['src']}";
      var imageResponse = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
          ),
          onReceiveProgress: (current, total) {
              currentDownProImg.insert(index,(current/total).toDouble());
          });
      var saveFile = File("${tmpDirectory.path}/image_$count.png");
      if (imageResponse.data != null) {
        saveFile.writeAsBytes(imageResponse.data);
      }
      if (count == 0) {
        currentDownPreview.insert(
            index, "${tmpDirectory.path}/image_$count.png");
      }
      count++;
      currentDownProgress.insert(index, (count / imagesSize).toDouble());
      currentDownPage.insert(index, count);
      update();
      print(saveFile);
    }
    if (checkIsClean()) {
      currentDownLink.removeRange(0, currentDownLink.length);
      currentDownProgress.removeRange(0, currentDownProgress.length);
    }
    update();
  }

  Future<String> getDownPreview(int index) async {
    if (currentDownPreview[index].isEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));
      await getDownPreview(index);
    }
    return currentDownPreview[index];
  }

  checkIsClean() {
    if (currentDownProgress.isEmpty) {
      return false;
    }
    for (double currentProgress in currentDownProgress) {
      if (currentProgress != 1.0) {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    currentDownProgress.value = [];
    currentDownLink.value = [];
    super.dispose();
  }
}
