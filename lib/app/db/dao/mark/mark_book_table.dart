import 'package:drift/drift.dart';

class MarkBookTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get markId =>
      integer().customConstraint('REFERENCES mark_table(id)')();

  IntColumn get bookId =>
      integer().customConstraint('REFERENCES book_table(id)')();
}
