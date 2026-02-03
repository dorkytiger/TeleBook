import 'package:drift/drift.dart';

class MarkTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get color => integer()();

  IntColumn get icon => integer()();

  TextColumn get description => text().nullable()();
}
