import 'package:drift/drift.dart';

class DownloadTaskTable extends Table {
  TextColumn get id => text()();

  TextColumn get groupId => text().nullable()();

  TextColumn get url => text()();

  TextColumn get fileName => text()();

  TextColumn get filePath => text()();

  TextColumn get status => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
