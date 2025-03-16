import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/book_page_layout_enum.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/book/book_controller.dart';

class BookPageController extends GetxController {
  final arguments = Get.arguments as Map<String, dynamic>;
  late final BookTableData book = arguments['book'];
  late final PageController pageController;
  final appDatabase = Get.find<AppDatabase>();
  final getBookState = Rx<RequestState<BookTableData>>(Idle());
  final bookController = Get.find<BookController>();
  final layout = Rx<BookPageLayout>(BookPageLayout.column);

  @override
  void onInit() async {
    super.onInit();
    await getBook();
  }

  Future<void> getBook() async {
    try {
      getBookState.value = Loading();
      final book = await (appDatabase.select(appDatabase.bookTable)
            ..where((e) => e.id.equals(this.book.id)))
          .getSingle();
      final settingData =
          await appDatabase.select(appDatabase.settingTable).getSingle();
      layout.value = BookPageLayout.values
          .firstWhere((e) => e.name == settingData.pageLayout);
      pageController = PageController(initialPage: book.readCount);
      getBookState.value = Success(book);
    } catch (e) {
      debugPrint(e.toString());
      getBookState.value = Error("获取图书失败：${e.toString()}");
    }
  }

  Future<void> onPageChanged(int index) async {
    try {
      final book = await (appDatabase.select(appDatabase.bookTable)
            ..where((e) => e.id.equals(this.book.id)))
          .getSingle();
      final newBookData = book.copyWith(readCount: index);
      await appDatabase.update(appDatabase.bookTable).replace(newBookData);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
