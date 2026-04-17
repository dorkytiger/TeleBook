import 'dart:async';

import 'package:dk_util/dk_util.dart';
import 'package:drift/drift.dart';
import 'package:tele_book/app/db/app_database.dart';

/// BookService 只负责管理 Book 基础数据
/// UI 需要的复合数据(VO)由 Controller 按需组装
class BookService {
  final AppDatabase db;

  BookService(this.db);

  Stream<List<BookTableData>> watchBooks() {
    return db.bookDao.watchBooks();
  }

  Future<BookTableData?> fetchById(int id) async {
    return await db.bookDao.getById(id);
  }

  Future<int> insert(BookTableCompanion companion) async {
    final id = await db.bookDao.insertBook(companion);
    return id;
  }

  /// 从导入事件直接构建并保存书籍
  Future<int> insertWithPaths({
    required String name,
    required List<String> localPaths,
  }) {
    DKLog.i("插入书籍：$name，路径：$localPaths");
    return insert(
      BookTableCompanion.insert(
        name: name,
        localPaths: localPaths,
        createdAt: Value(DateTime.now()),
      ),
    );
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
