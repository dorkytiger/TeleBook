import 'dart:async';

import 'package:drift/drift.dart';
import 'package:tele_book/app/db/app_database.dart';

class CollectionService {
  final AppDatabase db;

  CollectionService(this.db);

  Stream<List<CollectionTableData>> getCollections(String? name) {
    return db.collectionDao.getCollections(name);
  }

  Stream<List<CollectionBookTableData>> getCollectionBooks(int collectionId) {
    return db.collectionBookDao.getBooksInCollection(collectionId);
  }

  Future<void> updateBookCollection(int collectionId, int bookId) async {
    await db.transaction(() async {
      final existing = await db.collectionBookDao.getCollectionBook(
        collectionId,
        bookId,
      );
      if (existing != null) {
        // 已存在则删除（取消收藏）
        await db.collectionBookDao.deleteCollectionBook(existing.id);
      } else {
        // 不存在则添加
        await db.collectionBookDao.insertCollectionBook(collectionId, bookId);
      }
    });
  }

  Future<void> saveCollection({
    int? id,
    required String name,
    String? description,
  }) async {
    await db.transaction(() async {
      if (id == null) {
        // 新建
        await db.collectionDao.insertCollection(
          CollectionTableCompanion(
            name: Value(name),
            description: Value(description),
          ),
        );
      } else {
        // 更新
        await db.collectionDao.updateCollection(
          CollectionTableCompanion(
            id: Value(id),
            name: Value(name),
            description: Value(description),
          ),
        );
      }
    });
  }

  Future<void> deleteCollection(int collectionId) async {
    await db.transaction(() async {
      await (db.collectionTable.delete()
            ..where((tbl) => tbl.id.equals(collectionId)))
          .go();
      await (db.collectionBookTable.delete()
            ..where((tbl) => tbl.collectionId.equals(collectionId)))
          .go();
    });
  }
}
