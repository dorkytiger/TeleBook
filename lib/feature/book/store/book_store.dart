import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tele_book/feature/book/model/vo/book_vo.dart';
import 'package:tele_book/feature/book/enum/book_sort.dart';
import 'package:tele_book/feature/book/service/book_service.dart';

class BookStore extends ChangeNotifier {
  final BookService _bookService;
  final List<BookListItemVo> books = [];
  BookSort sort = BookSort(
    order: BookSortOrder.desc,
    type: BookSortType.lastCreatedAt,
  );
  final int pageSize = 20;

  int _currentPage = 1;
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
    _currentPage = 1;
    books.clear();
    _watchBooks(page: _currentPage);
  }

  /// 订阅书籍列表流
  void _watchBooks({int page = 1}) {
    _bookSubscription?.cancel();
    _bookSubscription = _bookService
        .watchBooks(
          page: page,
          pageSize: pageSize,
          name: _nameFilter,
          sort: sort,
        )
        .listen(
          (bookListVo) {
            if (page == 1) {
              // 第一页：清空并重新设置
              books.clear();
              books.addAll(bookListVo.bookVos);
            } else {
              // 后续页：追加
              books.addAll(bookListVo.bookVos);
            }

            // 判断是否还有更多数据
            _hasMore = bookListVo.bookVos.length >= pageSize;
            _isLoading = false;
            notifyListeners();
          },
          onError: (e) {
            _isLoading = false;
            notifyListeners();
          },
        );
  }

  /// 加载下一页
  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    notifyListeners();

    try {
      // 用非 watch 的 fetch 方法直接获取下一页，避免重复订阅
      final bookListVo = await _bookService.fetchBooks(
        page: _currentPage + 1,
        pageSize: pageSize,
        name: _nameFilter,
        sort: sort,
      );

      // 追加下一页数据
      books.addAll(bookListVo.bookVos);

      if (bookListVo.bookVos.isNotEmpty) {
        _currentPage += 1;
      }

      // 判断是否还有更多
      _hasMore = bookListVo.bookVos.length >= pageSize;
    } catch (e) {
      debugPrint('加载更多失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 搜索（重置分页）
  Future<void> search(String? name) async {
    _nameFilter = name;
    _loadFirstPage(); // 重载第一页
  }

  Future<void> updateReadProgress(int bookId, int progress) async {
    final book = books.firstWhere((b) => b.book.id == bookId).book;
    final updatedBook = book.copyWith(currentPage: progress);
    await _bookService.updateBook(updatedBook);
  }

  void updateSort(BookSort newSort) {
    if (sort == newSort) return;
    sort = newSort;

    _loadFirstPage(); // 重载第一页
  }

  @override
  void dispose() {
    _bookSubscription?.cancel();
    super.dispose();
  }
}
