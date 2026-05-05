import 'package:drift/drift.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/db/table/mark/mark_book_table.dart';

part 'mark_book_dao.g.dart';

@DriftAccessor(tables: [MarkBookTable])
class MarkBookDao extends DatabaseAccessor<AppDatabase>
    with _$MarkBookDaoMixin {
  MarkBookDao(super.attachedDatabase);

  Stream<List<MarkBookTableData>> getBooksInMark(int markId) {
    return (select(
      markBookTable,
    )..where((tbl) => tbl.markId.equals(markId))).watch();
  }

  Future<int> insertMarkBook(MarkBookTableCompanion companion) {
    return into(markBookTable).insert(companion);
  }

  Future<int> deleteByBookId(int bookId) {
    return (delete(
      markBookTable,
    )..where((tbl) => tbl.bookId.equals(bookId))).go();
  }

  Future<int> deleteByMarkId(int markId) {
    return (delete(
      markBookTable,
    )..where((tbl) => tbl.markId.equals(markId))).go();
  }
}
