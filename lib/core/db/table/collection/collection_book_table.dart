// language: dart
import 'package:drift/drift.dart';
import 'package:tele_book/feature/book/model/table/book_table.dart';
import 'package:tele_book/core/db/table/collection/collection_table.dart';

class CollectionBookTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get bookId => integer().references(BookTable, #id)();

  IntColumn get collectionId => integer().references(CollectionTable, #id)();

  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
}
