import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/ui/provider/book_provider.dart';

part 'book_page_provider.g.dart';

class BookPageState {
  final BookTableData book;
  final List<String> paths;
  final int currentPage;
  final bool isShowBar;

  BookPageState({
    required this.book,
    required this.paths,
    required this.currentPage,
    required this.isShowBar,
  });

  BookPageState copyWith({
    BookTableData? book,
    List<String>? paths,
    int? currentPage,
    bool? isShowBar,
  }) {
    return BookPageState(
      book: book ?? this.book,
      paths: paths ?? this.paths,
      currentPage: currentPage ?? this.currentPage,
      isShowBar: isShowBar ?? this.isShowBar,
    );
  }
}

@riverpod
class BookPage extends _$BookPage {
  late PageController pageController;

  @override
  BookPageState build(int bookId) {
    final book = ref
        .watch(bookListProvider)
        .value
        ?.bookVos
        .where((e) => e.book.id == bookId)
        .first
        .book;
    if (book == null) {
      throw Exception("Book not found");
    }

    final previewPaths = book.previewSubPaths;
    final fullPaths = (previewPaths != null && previewPaths.isNotEmpty)
        ? previewPaths.map((e) => GlobalConfig.resolveBookPath(e)).toList()
        : book.localSubPaths
            .map((e) => GlobalConfig.resolveBookPath(e))
            .toList();
    return BookPageState(
      book: book,
      paths: fullPaths,
      currentPage: book.currentPage,
      isShowBar: false,
    );
  }

  void initController(PageController controller) {
    pageController = controller;
  }

  void onPageChanged(int index) {
    state = state.copyWith(currentPage: index);
  }

  void toggleBar() {
    state = state.copyWith(isShowBar: !state.isShowBar);
  }
}
