import 'dart:async';

import 'package:drift/drift.dart';
import 'package:tele_book/app/db/app_database.dart';

class MarkService {
  final AppDatabase db;

  MarkService(this.db);

  Stream<List<MarkTableData>> getMarks(String? name) {
    return db.markDao.getMarks(name);
  }

  Stream<List<MarkBookTableData>> getBooksInMark(int markId) {
    return db.markBookDao.getBooksInMark(markId);
  }

  Future<void> updateBookMarks(int bookId, List<int> markIds) async {
    await db.transaction(() async {
      // 删除旧关联
      await db.markBookDao.deleteByBookId(bookId);

      // 添加新关联
      for (final markId in markIds) {
        await db.markBookDao.insertMarkBook(
          MarkBookTableCompanion(markId: Value(markId), bookId: Value(bookId)),
        );
      }
    });
  }

  Future<void> saveMark({
    int? id,
    required String name,
    String? description,
  }) async {
    await db.transaction(() async {
      if (id == null) {
        // 新建
        await db.markDao.insertMark(
          MarkTableCompanion(
            name: Value(name),
            description: Value(description),
          ),
        );
      } else {
        // 更新
        await db.markDao.updateMark(
          MarkTableCompanion(
            id: Value(id),
            name: Value(name),
            description: Value(description),
          ),
        );
      }
    });
  }

  Future<void> deleteMark(int id) async {
    await db.transaction(() async {
      // 删除关联的书籍
      await db.markBookDao.deleteByMarkId(id);

      // 删除标签
      await db.markDao.deleteById(id);
    });
  }
}
