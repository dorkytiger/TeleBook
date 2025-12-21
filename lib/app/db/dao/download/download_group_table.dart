import 'package:drift/drift.dart';

class DownloadGroupTable extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  // 任务统计
  IntColumn get totalCount => integer().withDefault(const Constant(0))();

  IntColumn get completedCount => integer().withDefault(const Constant(0))();

  IntColumn get failedCount => integer().withDefault(const Constant(0))();

  IntColumn get runningCount => integer().withDefault(const Constant(0))();

  // 组进度 (0-100)
  RealColumn get groupProgress => real().withDefault(const Constant(0.0))();

  // 时间记录
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
