import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookController extends GetxController {
  RxList<String> bookPreviewList = <String>[].obs;
  RxList<String> bookPathList = <String>[].obs;
  RxList<String> bookNameList = <String>[].obs;
  RxList<String> bookPageList = <String>[].obs;
  RxInt currentPage = 1.obs;
  RxBool hasMore = true.obs;
  RxString url = "".obs;
  TextEditingController urlController = TextEditingController();
  late SharedPreferences sharedPreferences;

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    getBookList();

    super.onInit();
  }

  getBook() async {
    String url = urlController.text;
    var response = await GetConnect().get(url);
    var htmlString = await response.body;
    var document = parse(htmlString);
    final title = document.querySelector("h1");
    final tmpFile = await getApplicationCacheDirectory();
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

  getBookList() async {
    try {
      bookPathList.value = [];
      bookNameList.value = [];
      bookPreviewList.value = [];
      final tmpFile = await getApplicationCacheDirectory();
      List<FileSystemEntity> fileList =
          Directory("${tmpFile.path}/book").listSync().toList();
      print(fileList);
      for (FileSystemEntity fileSystemEntity in fileList) {
        final book = Directory(fileSystemEntity.path).listSync();
        print(book);
        bookPathList.add(fileSystemEntity.path);
        print(fileSystemEntity.path);
        bookNameList.add(fileSystemEntity.path
            .substring(fileSystemEntity.path.lastIndexOf("/") + 1));
        bookPreviewList.add(book.first.path);
      }
    } catch (e) {
      print(e.toString());
    }
    update();
  }

  getBookPageList(String filePath) async {
    bookPageList.value = [];
    final pageList = Directory(filePath).listSync();
    for (var page in pageList) {
      if (page is File) {
        bookPageList.add(page.path);
      }
    }
    update();
  }
}
