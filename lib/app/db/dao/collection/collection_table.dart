import 'package:drift/drift.dart';


class CollectionTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get parentId => integer().nullable().references(CollectionTable, #id)();

  IntColumn get order => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
