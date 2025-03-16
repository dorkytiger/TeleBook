import 'package:drift/drift.dart';
import 'package:tele_book/app/db/converter/string_list_converter.dart';

class DownloadTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get bookId => integer()();

  TextColumn get name => text()();

  TextColumn get localPaths => text().map(const StringListConverter())();

  IntColumn get downloadCount => integer().withDefault(const Constant(0))();

  TextColumn get imageUrls => text().map(const StringListConverter())();
}
