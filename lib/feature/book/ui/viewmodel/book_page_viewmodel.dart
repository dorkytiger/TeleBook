import 'package:flutter/foundation.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';

class BookPageViewmodel extends ChangeNotifier {
  final BookTableData book;
  List<String> paths = [];
  String title = "";
  bool isShowBar = false;
  int currentPage = 0;

  BookPageViewmodel({required this.book}) {
    paths = book.localSubPaths
        .map((rel) => GlobalConfig.resolveBookPath(rel))
        .toList();
    title = book.name;
    currentPage = book.currentPage.clamp(0, paths.isEmpty ? 0 : paths.length - 1);
  }

  double get progress =>
      paths.isEmpty ? 0.0 : (currentPage + 1) / paths.length;

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
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
}
