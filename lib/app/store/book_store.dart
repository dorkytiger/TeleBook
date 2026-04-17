import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/service/book_service.dart';

class BookStore extends ChangeNotifier {
  final BookService _service;
  StreamSubscription? _bookStreamSubscription;

  List<BookTableData> _items = [];

  List<BookTableData> get items => _items;

  BookStore(this._service) {
    _bookStreamSubscription?.cancel();
    _bookStreamSubscription = _service.watchBooks().listen((event) {
      _items = event;
      notifyListeners();
    });
  }

  Future<BookTableData?> getBookById(int id) async {
    return await _service.fetchById(id);
  }

  Future<int> addBook(BookTableCompanion companion) async {
    int newId = await _service.insert(companion);
    notifyListeners();
    return newId;
  }

  Future<void> updateBook(BookTableData data) async {
    await _service.update(data);
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
