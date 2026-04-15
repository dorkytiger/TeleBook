import 'package:drift/drift.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/db/table/book/book_table.dart';

part 'book_dao.g.dart';

@DriftAccessor(tables: [BookTable])
class BookDao extends DatabaseAccessor<AppDatabase> with _$BookDaoMixin {
  BookDao(super.attachedDatabase);

  Stream<List<BookTableData>> getBooks(String? name) {
    final query = select(bookTable);
    if (name != null && name.isNotEmpty) {
      query.where((tbl) => tbl.name.like('%$name%'));
    }
    return query.watch();
  }

  /// Fetch a single page using LIMIT/OFFSET. Useful for pagination UI.
  Future<List<BookTableData>> getBooksPage({
    required int limit,
    required int offset,
    String? name,
  }) {
    final q = (select(bookTable)
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ])
      ..limit(limit, offset: offset));

    if (name != null && name.isNotEmpty) {
      q.where((tbl) => tbl.name.like('%$name%'));
    }

    return q.get();
  }

  /// Keyset pagination: get next page after [lastCreatedAt] (createdAt descending).
  Future<List<BookTableData>> getBooksAfterCreatedAt({
    DateTime? lastCreatedAt,
    required int limit,
    String? name,
  }) {
    final q = (select(bookTable)
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ])
      ..limit(limit));

    if (lastCreatedAt != null) {
      q.where((tbl) => tbl.createdAt.isSmallerThanValue(lastCreatedAt));
    }

    if (name != null && name.isNotEmpty) {
      q.where((tbl) => tbl.name.like('%$name%'));
    }

    return q.get();
  }

  Future<BookTableData?> getById(int id) async {
    return (select(bookTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertBook(BookTableCompanion companion) async {
    return into(bookTable).insert(companion);
  }

  Future<bool> updateBook(BookTableData book) async {
    return update(bookTable).replace(book);
  }

  Future<int> deleteById(int id) async {
    return (delete(bookTable)..where((t) => t.id.equals(id))).go();
  }
}
