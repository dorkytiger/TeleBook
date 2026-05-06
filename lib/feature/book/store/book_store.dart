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

  DateTime? _lastCreatedAt; // 用于 keyset 分页的游标
  String? _nameFilter;
  bool _isLoading = false;
  bool _hasMore = true;

  StreamSubscription<BookListVo>? _bookSubscription;

  BookStore(this._bookService) {
    _loadFirstPage();
  }

  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  /// 加载第一页
  void _loadFirstPage() {
    _lastCreatedAt = null;
    books.clear();
    _watchBooks(lastCreatedAt: null);
  }

  /// 订阅书籍列表流
  void _watchBooks({DateTime? lastCreatedAt}) {
    _bookSubscription?.cancel();
    _bookSubscription = _bookService
        .watchBooks(
          page: 1,
          pageSize: pageSize,
          lastCreatedAt: lastCreatedAt,
          name: _nameFilter,
          sort: sort,
        )
        .listen((bookListVo) {
          if (lastCreatedAt == null) {
            // 第一页：清空并重新设置
            books.clear();
            books.addAll(bookListVo.bookVos);
          } else {
            // 后续页：追加
            books.addAll(bookListVo.bookVos);
          }

          // 更新游标为本页最后一条记录的 createdAt
          if (bookListVo.bookVos.isNotEmpty) {
            _lastCreatedAt =
                bookListVo.bookVos.last.book.createdAt;
          }

          // 判断是否还有更多数据
          _hasMore = bookListVo.bookVos.length >= pageSize;
          _isLoading = false;
          notifyListeners();
        }, onError: (e) {
          _isLoading = false;
          notifyListeners();
        });
  }

  /// 加载下一页
  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    notifyListeners();

    // 用上一页的最后 createdAt 作为游标加载下一页
    _watchBooks(lastCreatedAt: _lastCreatedAt);
  }

  /// 搜索（重置分页）
  Future<void> search(String? name) async {
    _nameFilter = name;
    _loadFirstPage(); // 重载第一页
  }

  @override
  void dispose() {
    _bookSubscription?.cancel();
    super.dispose();
  }
}


