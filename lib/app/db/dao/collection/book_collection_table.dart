// language: dart
import 'package:drift/drift.dart';
import 'package:tele_book/app/db/dao/book/book_table.dart';
import 'package:tele_book/app/db/dao/collection/collection_table.dart';

class BookCollectionTable extends Table {
  IntColumn get bookId => integer().references(BookTable, #id)();

  IntColumn get collectionId => integer().references(CollectionTable, #id)();

  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {bookId, collectionId};
}
