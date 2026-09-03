import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/sync/model/table/sync_op_table.dart';

part 'sync_op_local_datasource.g.dart';

final syncOpLocalDatasourceProvider = Provider<SyncOpLocalDatasource>((
  ref,
) {
  return SyncOpLocalDatasource(ref.watch(databaseProvider));
});

/// 同步操作任务（组任务）数据访问：全局通知 + 队列调度的持久化状态。
@DriftAccessor(tables: [SyncOpTable])
class SyncOpLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$SyncOpLocalDatasourceMixin {
  SyncOpLocalDatasource(super.attachedDatabase);

  /// 新建一个任务（默认 waiting），返回 id。
  Future<int> insertTask({
    required String type,
    required String title,
    int totalBooks = 0,
    String? payload,
  }) {
    return into(syncOpTable).insert(
      SyncOpTableCompanion.insert(
        type: type,
        title: title,
        totalBooks: Value(totalBooks),
        payload: payload != null ? Value(payload) : const Value.absent(),
      ),
    );
  }

  /// 全部任务，按 id 升序（队列顺序）。
  Future<List<SyncOpTableData>> listAll() {
    return (select(syncOpTable)
          ..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .get();
  }

  /// 监听全部任务变化（全局通知/明细面板实时刷新）。
  Stream<List<SyncOpTableData>> watchAll() {
    return (select(syncOpTable)
          ..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .watch();
  }

  /// 当前进行中的任务（无则取第一个 waiting；执行时置 running）。
  Future<SyncOpTableData?> currentRunning() {
    return (select(syncOpTable)
          ..where((t) => t.status.equals('running'))
          ..limit(1))
        .getSingleOrNull();
  }

  /// 待执行任务（waiting + failed + interrupted 按 id 升序）。
  Future<List<SyncOpTableData>> listPending() {
    return (select(syncOpTable)
          ..where((t) => t.status.isIn(['waiting', 'failed', 'interrupted']))
          ..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .get();
  }

  /// 更新任务状态与进度。
  Future<void> updateTask(
    int id, {
    String? status,
    int? doneBooks,
    int? totalBooks,
    int? currentPage,
    int? totalPages,
    String? error,
  }) {
    return (update(syncOpTable)..where((t) => t.id.equals(id))).write(
      SyncOpTableCompanion(
        status: status != null ? Value(status) : const Value.absent(),
        doneBooks: doneBooks != null ? Value(doneBooks) : const Value.absent(),
        totalBooks: totalBooks != null ? Value(totalBooks) : const Value.absent(),
        currentPage: currentPage != null ? Value(currentPage) : const Value.absent(),
        totalPages: totalPages != null ? Value(totalPages) : const Value.absent(),
        error: error != null ? Value(error) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// App 启动：把遗留 running 任务标记为 interrupted（进程被杀恢复）。
  Future<void> markAllRunningInterrupted() {
    return (update(syncOpTable)..where((t) => t.status.equals('running'))).write(
      SyncOpTableCompanion(
        status: const Value('interrupted'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 删除任务（成功后清理）。
  Future<void> deleteTask(int id) {
    return (delete(syncOpTable)..where((t) => t.id.equals(id))).go();
  }
}
