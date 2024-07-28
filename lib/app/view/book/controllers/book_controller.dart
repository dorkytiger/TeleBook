import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/vo/book_vo.dart';
import '../../../service/book_service.dart';

class BookController extends GetxController {
  RxList<BookVO> bookList = <BookVO>[].obs;
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

  late final _bookService = BookService();

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

  @override
  void onReady() {
    getBookList();
    super.onReady();
  }

  /// 切换编辑状态
  void toggleEditing() {
    isEditing.value = !isEditing.value;
    selectedItems.clear(); // 清空选中的项
    update();
  }

  /// 切换选中状态
  void toggleSelection(int index) {
    if (selectedItems.contains(index)) {
      selectedItems.remove(index);
    } else {
      selectedItems.add(index);
    }
    update();
  }

  /// 删除选择的书籍
  deleteSelectedItems() async {
    try {
      Set<int> bookIds = {};
      for (var bookPathIndex in selectedItems) {
        final bookId = bookList[bookPathIndex].id;
        bookIds.add(bookId);
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
      await _bookService.deleteBooks(bookIds);
      selectedItems.clear();
      toggleEditing();
      getBookList();
      update();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  /// 更新
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
      final books = await _bookService.getBooks();
      bookList.value = books;
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  onClickBook(int index) {
    currentBookIndex.value = index;
    update();
  }
}
