import 'package:drift/drift.dart';

class CollectionTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get description => text().nullable()();

  TextColumn get coverImageSubPath => text().nullable()();
}
