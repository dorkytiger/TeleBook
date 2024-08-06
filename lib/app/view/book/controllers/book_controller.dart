import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wo_nas/app/view/book/views/book_page_view.dart';

import '../../../model/vo/book_vo.dart';
import '../../../service/book_service.dart';

class BookController extends GetxController {
  RxList<BookVO> bookList = <BookVO>[].obs;
  RxSet<int> selectedItems = <int>{}.obs;
  RxInt currentBookIndex = 0.obs;
  RxBool isEditing = false.obs;
  RxInt currentPage = 0.obs;

  TextEditingController urlController = TextEditingController();
  PageController pageController = PageController();

  late final _bookService = BookService();

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

  deleteBook(int index) async {
    try {
      final bookDir = Directory(bookList[index].path);
      if (bookDir.existsSync()) {
        final book = bookDir.listSync();
        for (var page in book) {
          page.deleteSync();
        }
        bookDir.deleteSync();
      }
      await _bookService.deleteBooks({bookList[index].id});
      getBookList();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    }
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
