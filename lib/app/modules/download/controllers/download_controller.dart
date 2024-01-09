import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';

class DownloadController extends GetxController {
  TextEditingController urlController = TextEditingController();
  RxList<String> currentDownLink = <String>[].obs;
  RxList<double> currentDownLoadProgress = <double>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  getBook() async {
    String url = urlController.text;
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
    var count = 0;
    for (var element in images) {
      var url = "https://telegra.ph${element.attributes['src']}";
      var imageResponse = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));
      var saveFile = File("${tmpDirectory.path}/image_$count.png");
      if (imageResponse.data != null) {
        saveFile.writeAsBytes(imageResponse.data);
      }
      count++;
      print(saveFile);
    }
  }
}
