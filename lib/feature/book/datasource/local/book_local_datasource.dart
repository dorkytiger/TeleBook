import 'package:drift/drift.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/enum/book_sort.dart';
import 'package:tele_book/feature/book/model/table/book_table.dart';


part 'book_local_datasource.g.dart';

@DriftAccessor(tables: [BookTable])
class BookLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$BookLocalDatasourceMixin {
  BookLocalDatasource(super.attachedDatabase);

  Stream<List<BookTableData>> watchBooks({
    int? page,
    int? pageSize,
    DateTime? lastCreatedAt,
    String? name,
    BookSort? sort,
  }) {
    final q = (select(bookTable)
      ..orderBy([
        (t) => sort != null
            ? OrderingTerm(
                expression: switch (sort.type) {
                  BookSortType.title => t.name,
                  BookSortType.lastCreatedAt => t.createdAt,
                },
                mode: switch (sort.order) {
                  BookSortOrder.asc => OrderingMode.asc,
                  BookSortOrder.desc => OrderingMode.desc,
                },
              )
            : OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ])
      ..limit(pageSize ?? 20, offset: ((page ?? 1) - 1) * (pageSize ?? 20)));

    if (lastCreatedAt != null) {
      q.where((tbl) => tbl.createdAt.isSmallerThanValue(lastCreatedAt));
    }

    if (name != null && name.isNotEmpty) {
      q.where((tbl) => tbl.name.like('%$name%'));
    }

    return q.watch();
  }

  Future<List<BookTableData>> getBooks({
    int? page,
    DateTime? lastCreatedAt,
    int limit = 20,
    String? name,
    BookSort? sort,
  }) async {
    final q = (select(bookTable)
      ..orderBy([
        (t) => sort != null
            ? OrderingTerm(
                expression: switch (sort.type) {
                  BookSortType.title => t.name,
                  BookSortType.lastCreatedAt => t.createdAt,
                },
                mode: switch (sort.order) {
                  BookSortOrder.asc => OrderingMode.asc,
                  BookSortOrder.desc => OrderingMode.desc,
                },
              )
            : OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ])
      ..limit(limit, offset: ((page ?? 1) - 1) * limit));

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
