import 'package:drift/drift.dart';
import 'package:tele_book/feature/book/model/table/book_table.dart';
import 'package:tele_book/core/db/table/mark/mark_table.dart';


class MarkBookTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get markId => integer().references(MarkTable, #id)();

  IntColumn get bookId => integer().references(BookTable, #id)();
}
