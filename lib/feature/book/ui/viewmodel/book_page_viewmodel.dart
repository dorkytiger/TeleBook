import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/service/book_service.dart';

class BookPageViewmodel extends ChangeNotifier {
  final BookTableData book;
  final BookService bookService;
  List<String> paths = [];
  String title = "";
  bool isShowBar = false;
  int currentPage = 0;
  late final PageController pageController;

  BookPageViewmodel({required this.book, required this.bookService}) {
    paths = book.localSubPaths
        .map((rel) => GlobalConfig.resolveBookPath(rel))
        .toList();
    title = book.name;
    currentPage = book.currentPage.clamp(
      0,
      paths.isEmpty ? 0 : paths.length - 1,
    );
    pageController = PageController(initialPage: currentPage);
  }

  double get progress => paths.isEmpty ? 0.0 : (currentPage + 1) / paths.length;

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  void jumpToPage(int index) {
    if (paths.isEmpty) return;
    final target = index.clamp(0, paths.length - 1);
    pageController.jumpToPage(target);
  }

  void toggleBar() {
    isShowBar = !isShowBar;
    notifyListeners();
  }

  void nextPage() {
    if (currentPage < paths.length - 1) {
      currentPage++;
      notifyListeners();
    }
  }

  void prevPage() {
    if (currentPage > 0) {
      currentPage--;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
