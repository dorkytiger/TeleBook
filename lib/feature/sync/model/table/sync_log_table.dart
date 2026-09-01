import 'package:drift/drift.dart';

/// 本地同步记录（每次 drain/同步会话一条）。
///
/// detail 存 JSON：{ books: [{ uuid, name, status, files: [{relPath, status}] }] }
/// status: running / completed / failed（会话级）；book/file 级：pending/syncing/done/failed。
class SyncLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  TextColumn get status => text()(); // running / completed / failed
  IntColumn get totalBooks => integer().withDefault(const Constant(0))();
  IntColumn get syncedBooks => integer().withDefault(const Constant(0))();
  IntColumn get failedBooks => integer().withDefault(const Constant(0))();
  TextColumn get detail => text().nullable()(); // 每本/每文件状态 JSON
}
