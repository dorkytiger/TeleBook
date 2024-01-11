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
  RxBool isEditing = false.obs;
  RxBool isShowTitle = false.obs;
  RxInt gridCount = 3.obs;
  RxSet<int> selectedItems = <int>{}.obs;
  RxString url = "".obs;
  TextEditingController urlController = TextEditingController();

  @override
  void onInit() async {
    final tmpFile = await getApplicationDocumentsDirectory();
    final tmpBooks = Directory("${tmpFile.path}/book");
    if (!tmpBooks.existsSync()) {
      tmpBooks.createSync();
    }
    getBookList();
    super.onInit();
  }

  // 切换编辑状态
  void toggleEditing() {
    isEditing.value = !isEditing.value;
    selectedItems.clear(); // 清空选中的项
    update();
  }

  // 切换选中状态
  void toggleSelection(int index) {
    if (selectedItems.contains(index)) {
      selectedItems.remove(index);
    } else {
      selectedItems.add(index);
    }
    update();
  }

  void deleteSelectedItems() {
    update();
  }

  void initGridCount() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var isTwice = sharedPreferences.getBool("isTwice");
    if (isTwice == null) {
      sharedPreferences.setBool("isTwice", false);
      isTwice = sharedPreferences.getBool("isTwice");
    }
    print(isTwice);
    if (isTwice!) {
      gridCount.value = 2;
    } else {
      gridCount.value = 3;
    }
    update();
  }

  // 设置是一行显示两个还是三个
  void setGridCount() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var isTwice = sharedPreferences.getBool("isTwice");
    sharedPreferences.setBool("isTwice", !isTwice!);
    print(isTwice);
    if (isTwice) {
      gridCount.value = 2;
    } else {
      gridCount.value = 3;
    }
    update();
  }

 Future<String> getConnect() async{
    String url=urlController.text;
    var response = await GetConnect().get(url);
    return await response.body;
  }

  getBook(String htmlString) async {
    final document=parse(htmlString);
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

  getBookList() async {
    try {
      bookPathList.value = [];
      bookNameList.value = [];
      bookPreviewList.value = [];
      final tmpFile = await getApplicationDocumentsDirectory();
      List<FileSystemEntity> fileList =
          Directory("${tmpFile.path}/book").listSync().toList();

      for (FileSystemEntity fileSystemEntity in fileList) {
        final book = Directory(fileSystemEntity.path).listSync();
        bookPathList.add(fileSystemEntity.path);
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

  deleteBookList() {
    print(selectedItems);
  }
}
