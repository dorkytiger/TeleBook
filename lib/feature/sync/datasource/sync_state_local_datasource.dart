import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/sync/model/table/entity_sync_state_table.dart';

part 'sync_state_local_datasource.g.dart';

final syncStateLocalDatasourceProvider = Provider<SyncStateLocalDatasource>((
  ref,
) {
  return SyncStateLocalDatasource(ref.watch(databaseProvider));
});

/// 实体同步状态（服务器版本号）数据访问。
@DriftAccessor(tables: [EntitySyncStateTable])
class SyncStateLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$SyncStateLocalDatasourceMixin {
  SyncStateLocalDatasource(super.attachedDatabase);

  /// 读取实体在服务器上的版本；从未同步过返回 null。
  Future<int?> getRevision(String entityType, String entityId) async {
    final row = await (select(entitySyncStateTable)
          ..where(
            (t) =>
                t.entityType.equals(entityType) &
                t.entityId.equals(entityId),
          ))
        .getSingleOrNull();
    return row?.serverRevision;
  }

  /// 记录/更新实体服务器版本（push 成功后调用）。
  Future<void> upsertRevision(
    String entityType,
    String entityId,
    int revision,
  ) {
    return into(entitySyncStateTable).insertOnConflictUpdate(
      EntitySyncStateTableCompanion.insert(
        entityType: entityType,
        entityId: entityId,
        serverRevision: Value(revision),
      ),
    );
  }

  /// 删除同步状态（实体被删除时清理）。
  Future<void> deleteState(String entityType, String entityId) async {
    await (delete(entitySyncStateTable)
          ..where(
            (t) =>
                t.entityType.equals(entityType) &
                t.entityId.equals(entityId),
          ))
        .go();
  }
}
