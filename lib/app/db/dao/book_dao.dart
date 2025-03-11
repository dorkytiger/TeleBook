import 'package:drift/drift.dart';
import 'package:wo_nas/app/db/converter/string_list_converter.dart';

class BookTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get localPaths => text().map(const StringListConverter())();

  BoolColumn get isDownload => boolean().withDefault(const Constant(false))();

  TextColumn get imageUrls => text().map(const StringListConverter())();
}
