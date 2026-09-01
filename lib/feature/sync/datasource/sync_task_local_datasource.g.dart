// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_task_local_datasource.dart';

// ignore_for_file: type=lint
mixin _$SyncTaskLocalDatasourceMixin on DatabaseAccessor<AppDatabase> {
  $SyncTaskTableTable get syncTaskTable => attachedDatabase.syncTaskTable;
  SyncTaskLocalDatasourceManager get managers =>
      SyncTaskLocalDatasourceManager(this);
}

class SyncTaskLocalDatasourceManager {
  final _$SyncTaskLocalDatasourceMixin _db;
  SyncTaskLocalDatasourceManager(this._db);
  $$SyncTaskTableTableTableManager get syncTaskTable =>
      $$SyncTaskTableTableTableManager(_db.attachedDatabase, _db.syncTaskTable);
}
