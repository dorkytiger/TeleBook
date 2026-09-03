import 'package:drift/drift.dart';
import 'package:tele_book/core/db/converter/string_list_converter.dart';

class BookTable extends Table {
  IntColumn get id => integer()();

  /// 跨设备稳定 ID（UUID，同步用）；本地 id 是 SQLite rowid。
  TextColumn get uuid => text().unique()();

  TextColumn get name => text()();

  TextColumn get localSubPaths => text().map(const StringListConverter())();

  TextColumn get coverSubPath => text().nullable()();

  TextColumn get previewSubPaths =>
      text().nullable().map(const StringListConverter())();

  IntColumn get readCount => integer().withDefault(const Constant(0))();

  IntColumn get currentPage => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
