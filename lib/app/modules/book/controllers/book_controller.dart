import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wo_nas/app/modules/book/data/book_data.dart';

class BookController extends GetxController {
  RxList<BookProp> bookList = <BookProp>[].obs;
  RxSet<int> selectedItems = <int>{}.obs;
  RxInt currentBookIndex = 0.obs;
  RxBool isEditing = false.obs;
  RxBool isShowTitle = false.obs;
  RxBool isTwice = false.obs;
  RxBool isShowProgress = false.obs;
  RxInt currentPage = 0.obs;
  RxInt gridCount = 2.obs;

  RxString url = "".obs;
  TextEditingController urlController = TextEditingController();
  PageController pageController = PageController();
  late SharedPreferences sharedPreferences;

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    gridCount.value = sharedPreferences.getBool("gridCount") == null
        ? 2
        : sharedPreferences.getBool("gridCount")!
            ? 2
            : 3;
    isShowTitle.value = sharedPreferences.getBool("showTitle") == null
        ? false
        : sharedPreferences.getBool("showTitle")!;
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

  deleteSelectedItems() async {
    try {
      for (var bookPathIndex in selectedItems) {
        final path = bookList[bookPathIndex].path;
        final bookDir = Directory(path);
        if (bookDir.existsSync()) {
          final book = bookDir.listSync();
          for (var page in book) {
            page.deleteSync();
          }
          bookDir.deleteSync();
        }
      }
      for (var index in selectedItems) {
        bookList.removeAt(index);
      }
      update();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  updateGridCount(bool isTwoRows) {
    gridCount.value = isTwoRows ? 2 : 3;
    update();
  }

  updateShowTitle(bool isShow) {
    isShowTitle.value = isShow;
    update();
  }

  getBookList() async {
    try {
      final tmpFile = await getApplicationDocumentsDirectory();
      List<FileSystemEntity> fileList =
          Directory("${tmpFile.path}/book").listSync().toList();
      if (fileList.isNotEmpty) {
        var newBookList = <BookProp>[];
        var count = 0;
        for (FileSystemEntity fileSystemEntity in fileList) {
          final book = Directory(fileSystemEntity.path).listSync();
          var title = fileSystemEntity.path
              .substring(fileSystemEntity.path.lastIndexOf("/") + 1);
          var preview = book.first.path;
          var path = fileSystemEntity.path;
          List<String> pictures = [];
          for (var page in book) {
            if (page is File) {
              pictures.add(page.path);
            }
          }
          newBookList.add(BookProp(
              id: count,
              title: title,
              path: path,
              preview: preview,
              pictures: pictures));
          count++;
        }
        bookList.value = newBookList;
      }
      update();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  onClickBook(int index) {
    currentBookIndex.value = index;
    update();
  }
}
