import 'dart:async';

import 'package:tele_book/app/db/app_database.dart';

/// BookService 只负责管理 Book 基础数据
/// UI 需要的复合数据(VO)由 Controller 按需组装
class BookService {
  final AppDatabase db;

  BookService(this.db);

  Future<List<BookTableData>> fetchPage({
    int limit = 30,
    int offset = 0,
    String? keyword,
  }) async {
    return db.bookDao.getBooksPage(limit: limit, offset: offset, name: keyword);
  }

  Future<List<BookTableData>> fetchAfter({
    DateTime? lastCreatedAt,
    int limit = 30,
    String? keyword,
  }) async {
    return db.bookDao.getBooksAfterCreatedAt(
      lastCreatedAt: lastCreatedAt,
      limit: limit,
      name: keyword,
    );
  }

  Future<void> insert(BookTableCompanion companion) async {
    await db.bookDao.insertBook(companion);
  }

  Future<void> delete(int id) async {
    await db.bookDao.deleteById(id);
  }

  Future<void> deleteBatch(List<int> ids) async {
    await db.transaction(() async {
      for (final id in ids) {
        await db.bookDao.deleteById(id);
      }
    });
  }
}
