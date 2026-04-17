import 'dart:async';
import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_query_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/store/book_store.dart';
import 'package:tele_book/app/store/collection_store.dart';
import 'package:tele_book/app/store/download_store.dart';
import 'package:tele_book/app/store/export_store.dart';
import 'package:tele_book/app/store/import_store.dart';
import 'package:tele_book/app/store/mark_store.dart';

/// 书籍页面控制器
/// 整合 BookStore、MarkStore、CollectionStore 和 ExportStore
class BookController extends ChangeNotifier {
  final BookStore bookStore;
  final MarkStore markStore;
  final CollectionStore collectionStore;
  final ExportStore exportStore;
  final ImportStore importStore;
  final DownloadStore downloadStore;
  final SharedPreferences sharedPreferences;
  final BuildContext context;

  // 多选模式状态
  bool multiEditMode = false;
  List<int> selectedBookIds = <int>[];

  // 布局和排序设置
  BookLayoutSetting bookLayout = BookLayoutSetting.list;
  BookSort sortBy = BookSort(
    type: BookSortType.title,
    order: BookSortOrder.asc,
  );

  // 书籍列表（组合了标签和收藏夹信息）
  List<BookVo> books = [];
  DKStateQuery<List<BookVo>> fetchBooksState = DkStateQueryIdle();

  BookController({
    required this.bookStore,
    required this.markStore,
    required this.collectionStore,
    required this.exportStore,
    required this.importStore,
    required this.downloadStore,
    required this.sharedPreferences,
    required this.context,
  }) {
    _init();
  }

  void _init() {
    // 监听各个 Store 的变化，自动刷新书籍列表
    bookStore.addListener(_onStoreChanged);
    markStore.addListener(_onStoreChanged);
    collectionStore.addListener(_onStoreChanged);
    importStore.addListener(_onStoreChanged);
    downloadStore.addListener(_onStoreChanged);
    exportStore.addListener(_onStoreChanged);

    // 初始加载
    fetchBooks();
  }

  void _onStoreChanged() {
    // 当任何 Store 变化时，重新构建 BookVo 列表
    fetchBooks();
  }

  /// 切换选择书籍
  void toggleSelectBook(int bookId) {
    if (selectedBookIds.contains(bookId)) {
      selectedBookIds.remove(bookId);
    } else {
      selectedBookIds.add(bookId);
    }
    notifyListeners();
  }

  /// 全选
  void toggleSelectAllBooks() {
    selectedBookIds.clear();
    selectedBookIds.addAll(books.map((b) => b.book.id));
    notifyListeners();
  }

  /// 取消全选
  void toggleDeselectAllBooks() {
    selectedBookIds.clear();
    notifyListeners();
  }

  /// 是否全选
  bool get isAllBooksSelected {
    if (books.isEmpty) return false;
    final allBookIds = books.map((b) => b.book.id).toSet();
    final selectedIds = selectedBookIds.toSet();
    return selectedIds.length == allBookIds.length &&
        allBookIds.every((id) => selectedIds.contains(id));
  }

  /// 切换多选模式
  void triggerMultiEditMode(bool enable) {
    multiEditMode = enable;
    if (!multiEditMode) {
      selectedBookIds.clear();
    }
    notifyListeners();
  }

  /// 改变排序方式
  void changeSortBy(BookSortType type, BookSortOrder order) {
    sortBy = BookSort(type: type, order: order);
    fetchBooks();
  }

  /// 加载书籍列表
  Future<void> fetchBooks() async {
    DKStateQueryHelper.triggerQuery(
      query: () async {
        final bookList = bookStore.items;
        final collections = collectionStore.collections;
        final collectionBooks = collectionStore.collectionBooks;
        final marks = markStore.marks;
        final markBooks = markStore.markBooks;

        List<BookVo> bookVos = [];

        for (var book in bookList) {
          // 获取书籍的标签
          final bookMarks = markBooks
              .where((mb) => mb.bookId == book.id)
              .map((mb) {
                try {
                  return marks.firstWhere((m) => m.id == mb.markId);
                } catch (_) {
                  return null;
                }
              })
              .whereType<MarkTableData>()
              .toList();

          // 获取书籍的收藏夹
          CollectionTableData? bookCollection;
          try {
            final cb = collectionBooks.firstWhere((cb) => cb.bookId == book.id);
            bookCollection = collections.firstWhere(
              (c) => c.id == cb.collectionId,
            );
          } catch (_) {
            bookCollection = null;
          }

          bookVos.add(
            BookVo(book: book, marks: bookMarks, collection: bookCollection),
          );
        }

        // 进行排序
        bookVos.sort((a, b) {
          int compareResult = 0;

          // 根据排序类型进行比较
          switch (sortBy.type) {
            case BookSortType.title:
              compareResult = a.book.name.compareTo(b.book.name);
              break;
            case BookSortType.addTime:
              compareResult = a.book.createdAt.compareTo(b.book.createdAt);
              break;
          }

          // 根据排序顺序调整结果
          return sortBy.order == BookSortOrder.asc
              ? compareResult
              : -compareResult;
        });

        return books = bookVos;
      },
      onStateChange: (value) {
        fetchBooksState = value;
        notifyListeners();
      },
    );
  }

  /// 搜索书籍
  List<BookVo> searchBooks(String searchText) {
    if (searchText.isEmpty) return books;
    return books
        .where((bookVo) => bookVo.book.name.contains(searchText))
        .toList();
  }

  /// 导出单本书籍
  Future<void> exportBook(BookTableData data) async {
    await exportStore.exportBook(data);

    // 导航到任务页面的导出 tab
    if (context.mounted) {
      context.go('/home?tab=1&taskTab=2'); // tab=1任务, taskTab=2导出
    }
  }

  /// 批量导出书籍
  Future<void> exportMultipleBooks() async {
    final ids = selectedBookIds.toList();
    final booksToExport = books
        .where((b) => ids.contains(b.book.id))
        .map((b) => b.book)
        .toList();

    // 添加所有书籍到导出队列
    await exportStore.exportMultiple(booksToExport);

    // 清除选择状态
    selectedBookIds.clear();
    multiEditMode = false;
    notifyListeners();

    // 导航到任务页面的导出 tab
    if (context.mounted) {
      context.go('/home?tab=1&taskTab=2');
    }
  }

  /// 删除单本书籍
  Future<void> deleteBook(int id) async {
    try {
      await bookStore.deleteBook(id);
      await fetchBooks();
    } catch (e) {
      debugPrint('Error deleting book: $e');
      rethrow;
    }
  }

  /// 批量删除书籍
  Future<void> deleteMultipleBooks() async {
    try {
      final ids = selectedBookIds.toList();
      await bookStore.deleteBooks(ids);
      selectedBookIds.clear();
      multiEditMode = false;
      await fetchBooks();
    } catch (e) {
      debugPrint('Error deleting books: $e');
      rethrow;
    }
  }

  /// 添加书籍到收藏夹
  Future<void> addBookToCollection(int bookId, int collectionId) async {
    try {
      await collectionStore.updateBookCollection(collectionId, bookId);
      // Store 会自动刷新
    } catch (e) {
      debugPrint('Error adding book to collection: $e');
      rethrow;
    }
  }

  /// 批量添加书籍到收藏夹
  Future<void> addMultipleBooksToCollection(int collectionId) async {
    try {
      for (final bookId in selectedBookIds) {
        await collectionStore.updateBookCollection(collectionId, bookId);
      }
      selectedBookIds.clear();
      multiEditMode = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding books to collection: $e');
      rethrow;
    }
  }

  /// 更新书籍的标签
  Future<void> updateBookMarks(int bookId, List<int> markIds) async {
    try {
      await markStore.updateBookMarks(bookId, markIds);
      // Store 会自动刷新
    } catch (e) {
      debugPrint('Error updating book marks: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    bookStore.removeListener(_onStoreChanged);
    markStore.removeListener(_onStoreChanged);
    collectionStore.removeListener(_onStoreChanged);
    super.dispose();
  }
}

/// 书籍视图对象（包含书籍、标签、收藏夹信息）
class BookVo {
  final BookTableData book;
  final List<MarkTableData> marks;
  final CollectionTableData? collection;

  BookVo({required this.book, required this.marks, required this.collection});
}

/// 书籍排序
class BookSort {
  final BookSortType type;
  final BookSortOrder order;

  BookSort({required this.type, required this.order});
}

enum BookSortOrder { asc, desc }

enum BookSortType { title, addTime }
