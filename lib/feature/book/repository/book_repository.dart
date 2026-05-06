import 'dart:io';

import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/util/failure_util.dart';
import 'package:tele_book/core/util/result_util.dart';
import 'package:tele_book/feature/book/datasource/local/book_local_datasource.dart';
import 'package:tele_book/feature/book/enum/book_sort.dart';
import 'package:uuid/uuid.dart';

import '../../../common/config/global_config.dart';

class BookRepository {
  final AppDatabase _db;
  late final BookLocalDatasource _bookLocalDatasource = _db.bookLocalDatasource;

  BookRepository(this._db);

  Stream<List<BookTableData>> watchBooks({
    int? page,
    int? pageSize,
    DateTime? lastCreatedAt,
    String? name,
    BookSort? sort,
  }) {
    return _bookLocalDatasource.watchBooks(
      page: page,
      pageSize: pageSize,
      lastCreatedAt: lastCreatedAt,
      name: name,
      sort: sort,
    );
  }

  Future<void> insertBook(BookTableCompanion book) {
    return _bookLocalDatasource.insertBook(book);
  }

  Future<void> updateBook(BookTableData book) {
    return _bookLocalDatasource.updateBook(book);
  }

  Future<Result<void>> saveToBook(
    List<String> sourcePaths,
    String title,
  ) async {
    try {
      final bookId = Uuid().v4();
      // 目标目录使用 GlobalConfig.booksDir/bookId
      final bookDir = Directory('${GlobalConfig.booksDir.path}/$bookId');
      if (!await bookDir.exists()) {
        await bookDir.create(recursive: true);
      }

      // 只存相对子路径（bookId/序号），不存绝对路径，避免重启后路径失效
      final relativeSubPaths = <String>[];
      for (var index = 0; index < sourcePaths.length; index++) {
        final srcPath = sourcePaths[index];
        final srcFile = File(srcPath);
        if (!await srcFile.exists()) {
          throw FileSystemException(
            'downloaded source file not found',
            srcPath,
          );
        }
        final fileName = index.toString().padLeft(7, '0');
        final destPath = '${bookDir.path}/$fileName';
        await srcFile.copy(destPath);
        // 只保存相对部分：bookId/序号
        relativeSubPaths.add('$bookId/$fileName');
      }

      final book = BookTableCompanion.insert(
        name: title,
        localSubPaths: relativeSubPaths,
      );
      await _bookLocalDatasource.insertBook(book);
      return Result.success(null);
    } catch (e, startTrace) {
      return Result.failure(
        BusinessFailure(message: '保存书籍失败', details: e, stackTrace: startTrace),
      );
    }
  }
}
