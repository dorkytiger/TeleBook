import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wo_nas/app/db/app_database.dart';
import 'package:wo_nas/app/view/book/view/book_page_view.dart';

import '../../model/vo/book_vo.dart';

class BookController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();
  RxList<BookTableData> bookList = <BookTableData>[].obs;
  RxSet<int> selectedItems = <int>{}.obs;
  RxInt currentBookIndex = 0.obs;
  RxBool isEditing = false.obs;
  RxInt currentPage = 0.obs;

  TextEditingController urlController = TextEditingController();
  PageController pageController = PageController();

  @override
  void onInit() async {
    getBookList();
    super.onInit();
  }

  /// 切换编辑状态
  void toggleEditing() {
    isEditing.value = !isEditing.value;
    selectedItems.clear(); // 清空选中的项
    update();
  }

  /// 点击卡片
  void onClickCard(int index) {
    if (isEditing.value) {
      toggleSelection(index);
    } else {
      currentBookIndex.value = index;
      Get.to(const BookPageView());
    }
  }

  /// 切换选中状态
  void toggleSelection(int index) {
    if (selectedItems.contains(index)) {
      selectedItems.remove(index);
    } else {
      selectedItems.add(index);
    }
    selectedItems.refresh();
  }

  /// 删除选择的书籍
  deleteBooks() async {
    try {
      // Set<int> bookIds = {};
      // for (var bookPathIndex in selectedItems) {
      //   final bookId = bookList[bookPathIndex].id;
      //   bookIds.add(bookId);
      //   final path = bookList[bookPathIndex].path;
      //   final bookDir = Directory(path);
      //   if (bookDir.existsSync()) {
      //     final book = bookDir.listSync();
      //     for (var page in book) {
      //       page.deleteSync();
      //     }
      //     bookDir.deleteSync();
      //   }
      // }
      // selectedItems.clear();
      // toggleEditing();
      // getBookList();
      // update();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  deleteBook(int index) async {
    try {
      // final bookDir = Directory(bookList[index].path);
      // if (bookDir.existsSync()) {
      //   final book = bookDir.listSync();
      //   for (var page in book) {
      //     page.deleteSync();
      //   }
      //   bookDir.deleteSync();
      // }
      // getBookList();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> getBookList() async {
    try {
      final bookList = await appDatabase.select(appDatabase.bookTable).get();
      this.bookList.value = bookList;
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  onClickBook(int index) {
    currentBookIndex.value = index;
    update();
  }
}
