import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/sync/model/table/sync_task_table.dart';

part 'sync_task_local_datasource.g.dart';

final syncTaskLocalDatasourceProvider = Provider<SyncTaskLocalDatasource>((
  ref,
) {
  return SyncTaskLocalDatasource(ref.watch(databaseProvider));
});

/// 待同步任务（outbox）数据访问。
@DriftAccessor(tables: [SyncTaskTable])
class SyncTaskLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$SyncTaskLocalDatasourceMixin {
  SyncTaskLocalDatasource(super.attachedDatabase);

  Future<int> insertTask(SyncTaskTableCompanion task) {
    return into(syncTaskTable).insert(task);
  }

  /// 待处理任务（pending），按 id 升序保证同一实体的操作顺序。
  Future<List<SyncTaskTableData>> listPending() {
    return (select(syncTaskTable)
          ..where((t) => t.status.equals('pending'))
          ..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .get();
  }

  /// 待同步任务数（底栏提示用）。
  Future<int> countPending() async {
    final row = await (selectOnly(syncTaskTable)
          ..addColumns([syncTaskTable.id.count()])
          ..where(syncTaskTable.status.equals('pending')))
        .getSingle();
    return row.read(syncTaskTable.id.count()) ?? 0;
  }

  /// 任务已成功推送 → 移除。
  Future<void> removeTask(int id) {
    return (delete(syncTaskTable)..where((t) => t.id.equals(id))).go();
  }

  /// 推送失败 → 标记 failed（保留任务，下次 drain 重试；status 不参与 pending）。
  Future<void> markFailed(int id) {
    return (update(syncTaskTable)..where((t) => t.id.equals(id))).write(
      const SyncTaskTableCompanion(status: Value('failed')),
    );
  }

  /// 高频变更（如阅读进度）合并到该实体最近的 pending upsert 任务：
  /// 只更新 payload 里的 name/current_page，不新增任务，避免 outbox 膨胀。
  /// 返回是否命中已有任务（false 表示没有 pending upsert，调用方应新增）。
  Future<bool> mergePendingUpsert({
    required String entityId,
    required String name,
    required int currentPage,
  }) async {
    final pending = await (select(syncTaskTable)
          ..where(
            (t) =>
                t.entityId.equals(entityId) &
                t.op.equals('upsert') &
                t.status.equals('pending'),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)]))
        .get();
    if (pending.isEmpty) return false;
    // 只保留最新一条，其余删除（历史进度不需要逐条推送）
    final latest = pending.first;
    for (final t in pending.skip(1)) {
      await (delete(syncTaskTable)..where((r) => r.id.equals(t.id))).go();
    }
    Map<String, dynamic> payload = {};
    if (latest.payload != null && latest.payload!.isNotEmpty) {
      payload = jsonDecode(latest.payload!) as Map<String, dynamic>;
    }
    payload['name'] = name;
    payload['current_page'] = currentPage;
    await (update(syncTaskTable)..where((t) => t.id.equals(latest.id))).write(
      SyncTaskTableCompanion(payload: Value(jsonEncode(payload))),
    );
    return true;
  }
}
