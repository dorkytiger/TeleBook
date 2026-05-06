import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/datasource/local/book_local_datasource.dart';
import 'package:tele_book/feature/book/enum/book_sort.dart';


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
    return _bookLocalDatasource
        .watchBooks(
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

}
