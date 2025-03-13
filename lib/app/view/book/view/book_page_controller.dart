import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wo_nas/app/db/app_database.dart';
import 'package:wo_nas/app/util/request_state.dart';

class BookPageController extends GetxController {
  final arguments = Get.arguments as Map<String, dynamic>;
  late final BookTableData book = arguments['book'];
  final appDatabase = Get.find<AppDatabase>();
  late final PageController pageController;
  final getBookState = Rx<RequestState<BookTableData>>(Idle());

  @override
  void onInit() {
    super.onInit();
    getBook();
  }

  Future<void> getBook() async {
    try {
      getBookState.value = Loading();
      final book = await (appDatabase.select(appDatabase.bookTable)
            ..where((e) => e.id.equals(this.book.id)))
          .getSingle();
      pageController = PageController(initialPage: book.readCount);
      debugPrint("初始页码：${book.readCount}");
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
      debugPrint("保存成功");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

}
