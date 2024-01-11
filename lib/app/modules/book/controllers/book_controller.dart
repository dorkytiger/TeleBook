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
  RxBool isTwice = false.obs;
  RxInt gridCount = 3.obs;
  RxSet<int> selectedItems = <int>{}.obs;
  RxString url = "".obs;
  TextEditingController urlController = TextEditingController();
  late SharedPreferences sharedPreferences;

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
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

  void deleteSelectedItems() async {
    try {
      for (var bookPathIndex in selectedItems) {
        final path = bookPathList[bookPathIndex];
        final bookDir = Directory(path);
        if (bookDir.existsSync()) {
          await bookDir.delete();
        }
      }
      update();
    } catch (e) {
      print(e);
    }
  }

  void initGridCount() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setGridCount();
  }

  // 设置是一行显示两个还是三个
  void setGridCount() async {
    var isTwice = sharedPreferences.getBool("isTwice") ?? false;
    sharedPreferences.setBool("isTwice", !isTwice);
    if (!isTwice) {
      gridCount.value = 2;
      update();
    } else {
      gridCount.value = 3;
      update();
    }
  }

  Future<String> getConnect() async {
    String url = urlController.text;
    var response = await GetConnect().get(url);
    return await response.body;
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
}
