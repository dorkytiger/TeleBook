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

  Future<BookTableData?> fetchById(int id) async {
    return await db.bookDao.getById(id);
  }

  Future<int> insert(BookTableCompanion companion) async {
    return await db.bookDao.insertBook(companion);
  }

  Future<void> update(BookTableData data) async {
    await db.bookDao.updateBook(data);
  }

  Future<void> updateReadProgress(int id, int progress) async {
    final book = await db.bookDao.getById(id);
    if (book == null) return;
    await db.bookDao.updateBook(book.copyWith(readCount: progress));
  }

  Future<int> delete(int id) async {
    return await db.bookDao.deleteById(id);
  }

  Future<void> deleteBatch(List<int> ids) async {
    await db.transaction(() async {
      for (final id in ids) {
        await db.bookDao.deleteById(id);
      }
    });
  }
}
