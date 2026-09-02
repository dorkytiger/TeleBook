import 'package:drift/drift.dart';

/// 待下载书籍的单个文件（页级断点，§8.1）。
class SyncDownFileTable extends Table {
  /// 所属书 uuid。
  TextColumn get uuid => text()();

  /// 书籍内相对路径（如 cover.jpg / original/0000000）。
  TextColumn get relPath => text()();

  TextColumn get hash => text()();

  IntColumn get size => integer().withDefault(const Constant(0))();

  /// 文件状态：pending(待下载) / syncing(下载中) / done(已完成) / failed(失败)。
  TextColumn get status => text().withDefault(const Constant('pending'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {uuid, relPath};
}
