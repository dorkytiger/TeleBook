import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/service/mark_service.dart';

/// 标签状态管理
class MarkStore extends ChangeNotifier {
  final MarkService _service;

  List<MarkTableData> marks = [];
  List<MarkBookTableData> markBooks = [];
  bool isLoading = false;

  StreamSubscription? _marksSubscription;
  StreamSubscription? _markBooksSubscription;

  MarkStore(this._service) {
    _init();
  }

  void _init() {
    // 监听所有标签
    _marksSubscription = _service.getMarks(null).listen((data) {
      marks = data;
      notifyListeners();
    });
  }

  /// 获取指定标签下的书籍
  Future<void> loadMarkBooks(int markId) async {
    isLoading = true;
    notifyListeners();

    try {
      _markBooksSubscription?.cancel();
      _markBooksSubscription = _service.getBooksInMark(markId).listen((data) {
        markBooks = data;
        isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// 获取所有标签-书籍关联（用于 BookController）
  Stream<List<MarkBookTableData>> getAllMarkBooks() {
    // 这里需要从数据库获取所有关联
    // 暂时返回空 Stream，需要在 MarkService 中添加对应方法
    return Stream.value(markBooks);
  }

  /// 更新书籍的标签
  Future<void> updateBookMarks(int bookId, List<int> markIds) async {
    await _service.updateBookMarks(bookId, markIds);
    // Stream 会自动更新
  }

  /// 保存标签（新建或更新）
  Future<void> saveMark({
    int? id,
    required String name,
    String? description,
  }) async {
    await _service.saveMark(id: id, name: name, description: description);
    // Stream 会自动更新
  }

  /// 删除标签
  Future<void> deleteMark(int id) async {
    await _service.deleteMark(id);
    // Stream 会自动更新
  }

  /// 根据书籍ID获取其标签
  List<MarkTableData> getMarksByBookId(int bookId) {
    final bookMarkIds = markBooks
        .where((mb) => mb.bookId == bookId)
        .map((mb) => mb.markId)
        .toList();
    return marks.where((m) => bookMarkIds.contains(m.id)).toList();
  }

  @override
  void dispose() {
    _marksSubscription?.cancel();
    _markBooksSubscription?.cancel();
    super.dispose();
  }
}

