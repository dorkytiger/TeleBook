// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_state_local_datasource.dart';

// ignore_for_file: type=lint
mixin _$SyncStateLocalDatasourceMixin on DatabaseAccessor<AppDatabase> {
  $EntitySyncStateTableTable get entitySyncStateTable =>
      attachedDatabase.entitySyncStateTable;
  SyncStateLocalDatasourceManager get managers =>
      SyncStateLocalDatasourceManager(this);
}

class SyncStateLocalDatasourceManager {
  final _$SyncStateLocalDatasourceMixin _db;
  SyncStateLocalDatasourceManager(this._db);
  $$EntitySyncStateTableTableTableManager get entitySyncStateTable =>
      $$EntitySyncStateTableTableTableManager(
        _db.attachedDatabase,
        _db.entitySyncStateTable,
      );
}
