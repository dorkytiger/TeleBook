import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/sync/model/table/sync_log_table.dart';

part 'sync_log_local_datasource.g.dart';

final syncLogLocalDatasourceProvider = Provider<SyncLogLocalDatasource>((
  ref,
) {
  return SyncLogLocalDatasource(ref.watch(databaseProvider));
});

/// 本地同步记录数据访问。
@DriftAccessor(tables: [SyncLogTable])
class SyncLogLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$SyncLogLocalDatasourceMixin {
  SyncLogLocalDatasource(super.attachedDatabase);

  Future<int> insertLog(SyncLogTableCompanion log) {
    return into(syncLogTable).insert(log);
  }

  /// 按 id 倒序（最新在前）。
  Future<List<SyncLogTableData>> listLogs({int limit = 100}) {
    return (select(syncLogTable)
          ..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
          ..limit(limit))
        .get();
  }

  Future<SyncLogTableData?> getLog(int id) {
    return (select(syncLogTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// 监听单条记录变化（同步会话期间进度持续写库，详情页实时刷新用）。
  Stream<SyncLogTableData?> watchLog(int id) {
    return (select(syncLogTable)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<void> updateLog(
    int id, {
    DateTime? finishedAt,
    String? status,
    int? totalBooks,
    int? syncedBooks,
    int? failedBooks,
    String? detail,
  }) {
    return (update(syncLogTable)..where((t) => t.id.equals(id))).write(
      SyncLogTableCompanion(
        finishedAt: finishedAt != null ? Value(finishedAt) : const Value.absent(),
        status: status != null ? Value(status) : const Value.absent(),
        totalBooks: totalBooks != null ? Value(totalBooks) : const Value.absent(),
        syncedBooks: syncedBooks != null ? Value(syncedBooks) : const Value.absent(),
        failedBooks: failedBooks != null ? Value(failedBooks) : const Value.absent(),
        detail: detail != null ? Value(detail) : const Value.absent(),
      ),
    );
  }
}
