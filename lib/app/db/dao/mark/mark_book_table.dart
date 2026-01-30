import 'package:drift/drift.dart';
import 'package:tele_book/app/db/dao/mark/mark_table.dart';

class MarkBookTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get markId => integer().references(MarkTable, #id)();

  IntColumn get bookId => integer().references(MarkTable, #id)();
}
