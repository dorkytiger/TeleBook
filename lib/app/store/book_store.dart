import 'dart:async';

import 'package:dk_util/dk_util.dart';
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
    DKLog.t("Saving read progress for bookId=$bookId, progress=$progress");
    await _service.updateReadProgress(bookId, progress);
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
