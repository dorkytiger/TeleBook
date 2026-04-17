import 'package:flutter/cupertino.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/service/book_service.dart';

class BookStore extends ChangeNotifier {
  final BookService _service;

  List<BookTableData> items = [];
  bool isLoading = false;
  bool isRefreshing = false;
  bool hasMore = true;
  DateTime? _cursor;
  String? keyword;

  BookStore(this._service);

  Future<void> refresh({String? newKeyword}) async {
    keyword = newKeyword;
    isRefreshing = true;
    notifyListeners();
    try {
      items.clear();
      _cursor = null;
      hasMore = true;
      await loadMore(); // loads first page
    } finally {
      isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> loadMore({int pageSize = 30}) async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    notifyListeners();
    try {
      final page = await _service.fetchAfter(
        lastCreatedAt: _cursor,
        limit: pageSize,
        keyword: keyword,
      );
      if (page.isEmpty) {
        hasMore = false;
      } else {
        items.addAll(page);
        _cursor = page.last.createdAt;
        if (page.length < pageSize) hasMore = false;
      }
    } catch (e) {
      // handle error: set an error field or rethrow
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<BookTableData?> getBookById(int id) async {
    return await _service.fetchById(id);
  }

  Future<int> addBook(BookTableCompanion companion) async {
    int newId = await _service.insert(companion);
    notifyListeners();
    return newId;
  }

  Future<void> saveReadProgress(int bookId, int progress) async {
    await _service.updateReadProgress(bookId, progress);
    // 更新本地数据
    final index = items.indexWhere((item) => item.id == bookId);
    if (index != -1) {
      items[index] = items[index].copyWith(readCount: progress);
      notifyListeners();
    }
  }

  Future<void> deleteBook(int id) async {
    await _service.delete(id);
    items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Future<void> deleteBooks(List<int> ids) async {
    await _service.deleteBatch(ids);
    items.removeWhere((item) => ids.contains(item.id));
    notifyListeners();
  }
}
