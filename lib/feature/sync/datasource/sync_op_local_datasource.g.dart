// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_op_local_datasource.dart';

// ignore_for_file: type=lint
mixin _$SyncOpLocalDatasourceMixin on DatabaseAccessor<AppDatabase> {
  $SyncOpTableTable get syncOpTable => attachedDatabase.syncOpTable;
  SyncOpLocalDatasourceManager get managers =>
      SyncOpLocalDatasourceManager(this);
}

class SyncOpLocalDatasourceManager {
  final _$SyncOpLocalDatasourceMixin _db;
  SyncOpLocalDatasourceManager(this._db);
  $$SyncOpTableTableTableManager get syncOpTable =>
      $$SyncOpTableTableTableManager(_db.attachedDatabase, _db.syncOpTable);
}
