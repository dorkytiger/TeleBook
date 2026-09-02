// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_upload_local_datasource.dart';

// ignore_for_file: type=lint
mixin _$SyncUploadLocalDatasourceMixin on DatabaseAccessor<AppDatabase> {
  $SyncUploadTableTable get syncUploadTable => attachedDatabase.syncUploadTable;
  SyncUploadLocalDatasourceManager get managers =>
      SyncUploadLocalDatasourceManager(this);
}

class SyncUploadLocalDatasourceManager {
  final _$SyncUploadLocalDatasourceMixin _db;
  SyncUploadLocalDatasourceManager(this._db);
  $$SyncUploadTableTableTableManager get syncUploadTable =>
      $$SyncUploadTableTableTableManager(
        _db.attachedDatabase,
        _db.syncUploadTable,
      );
}
