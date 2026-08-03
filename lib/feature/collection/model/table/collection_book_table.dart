import 'package:drift/drift.dart';

class CollectionBookTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get collectionId => integer()();

  IntColumn get bookId => integer()();
}
