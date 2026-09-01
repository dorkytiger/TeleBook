// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_log_local_datasource.dart';

// ignore_for_file: type=lint
mixin _$SyncLogLocalDatasourceMixin on DatabaseAccessor<AppDatabase> {
  $SyncLogTableTable get syncLogTable => attachedDatabase.syncLogTable;
  SyncLogLocalDatasourceManager get managers =>
      SyncLogLocalDatasourceManager(this);
}

class SyncLogLocalDatasourceManager {
  final _$SyncLogLocalDatasourceMixin _db;
  SyncLogLocalDatasourceManager(this._db);
  $$SyncLogTableTableTableManager get syncLogTable =>
      $$SyncLogTableTableTableManager(_db.attachedDatabase, _db.syncLogTable);
}
