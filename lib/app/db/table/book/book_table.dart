import 'package:drift/drift.dart';
import 'package:tele_book/app/db/converter/string_list_converter.dart';

class BookTable extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text()();

  TextColumn get localPaths => text().map(const StringListConverter())();

  IntColumn get readCount => integer().withDefault(const Constant(0))();

  IntColumn get currentPage => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
