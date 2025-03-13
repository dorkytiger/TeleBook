import 'package:drift/drift.dart';
import 'package:wo_nas/app/db/converter/string_list_converter.dart';

class BookTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get baseUrl => text()();

  TextColumn get localPaths => text().map(const StringListConverter())();

  IntColumn get downloadCount => integer().withDefault(const Constant(0))();

  BoolColumn get isDownload => boolean().withDefault(const Constant(false))();

  TextColumn get imageUrls => text().map(const StringListConverter())();

  IntColumn get readCount => integer().withDefault(const Constant(0))();

  TextColumn get createTime => text()();
}
