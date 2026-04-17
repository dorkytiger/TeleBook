import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/service/collection_servcie.dart';

/// 收藏夹状态管理
class CollectionStore extends ChangeNotifier {
  final CollectionService _service;

  List<CollectionTableData> collections = [];
  List<CollectionBookTableData> collectionBooks = [];
  bool isLoading = false;

  StreamSubscription? _collectionsSubscription;
  StreamSubscription? _collectionBooksSubscription;

  CollectionStore(this._service) {
    _init();
  }

  void _init() {
    // 监听所有收藏夹
    _collectionsSubscription = _service.getCollections(null).listen((data) {
      collections = data;
      notifyListeners();
    });
  }

  /// 获取指定收藏夹下的书籍
  Future<void> loadCollectionBooks(int collectionId) async {
    isLoading = true;
    notifyListeners();

    try {
      _collectionBooksSubscription?.cancel();
      _collectionBooksSubscription =
          _service.getCollectionBooks(collectionId).listen((data) {
        collectionBooks = data;
        isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// 更新书籍的收藏夹（切换收藏/取消收藏）
  Future<void> updateBookCollection(int collectionId, int bookId) async {
    await _service.updateBookCollection(collectionId, bookId);
    // Stream 会自动更新
  }

  /// 保存收藏夹（新建或更新）
  Future<void> saveCollection({
    int? id,
    required String name,
    String? description,
  }) async {
    await _service.saveCollection(
      id: id,
      name: name,
      description: description,
    );
    // Stream 会自动更新
  }

  /// 删除收藏夹
  Future<void> deleteCollection(int id) async {
    await _service.deleteCollection(id);
    // Stream 会自动更新
  }

  /// 根据书籍ID获取其收藏夹
  CollectionTableData? getCollectionByBookId(int bookId) {
    try {
      final collectionBook = collectionBooks.firstWhere(
        (cb) => cb.bookId == bookId,
      );
      return collections.firstWhere((c) => c.id == collectionBook.collectionId);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _collectionsSubscription?.cancel();
    _collectionBooksSubscription?.cancel();
    super.dispose();
  }
}