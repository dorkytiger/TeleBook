// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_down_local_datasource.dart';

// ignore_for_file: type=lint
mixin _$SyncDownLocalDatasourceMixin on DatabaseAccessor<AppDatabase> {
  $SyncDownTableTable get syncDownTable => attachedDatabase.syncDownTable;
  $SyncDownFileTableTable get syncDownFileTable =>
      attachedDatabase.syncDownFileTable;
  SyncDownLocalDatasourceManager get managers =>
      SyncDownLocalDatasourceManager(this);
}

class SyncDownLocalDatasourceManager {
  final _$SyncDownLocalDatasourceMixin _db;
  SyncDownLocalDatasourceManager(this._db);
  $$SyncDownTableTableTableManager get syncDownTable =>
      $$SyncDownTableTableTableManager(_db.attachedDatabase, _db.syncDownTable);
  $$SyncDownFileTableTableTableManager get syncDownFileTable =>
      $$SyncDownFileTableTableTableManager(
        _db.attachedDatabase,
        _db.syncDownFileTable,
      );
}
