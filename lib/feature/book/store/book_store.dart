import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tele_book/feature/book/enum/book_sort.dart';
import 'package:tele_book/feature/book/model/vo/book_vo.dart';
import 'package:tele_book/feature/book/service/book_service.dart';

class BookStore extends ChangeNotifier {
  final BookService _bookService;
  final List<BookListItemVo> books = [];
  final BookSort sort = BookSort(
    order: BookSortOrder.asc,
    type: BookSortType.lastCreatedAt,
  );
  final int pageSize = 20;
  int currentPage = 1;
  final String? nameFilter = null;
  final DateTime? lastCreatedAt = null;
  late final StreamSubscription<BookListVo>? _bookSubscription;

  BookStore(this._bookService) {
    _bookSubscription = _bookService
        .watchBooks(
          page: currentPage,
          pageSize: pageSize,
          lastCreatedAt: lastCreatedAt,
          name: nameFilter,
          sort: sort,
        )
        .listen((bookListVo) {
          books.clear();
          books.addAll(bookListVo.bookVos);
          notifyListeners();
        });
  }

  @override
  void dispose() {
    _bookSubscription?.cancel();
    super.dispose();
  }
}
