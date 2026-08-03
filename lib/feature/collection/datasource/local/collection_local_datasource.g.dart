// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_local_datasource.dart';

// ignore_for_file: type=lint
mixin _$CollectionLocalDatasourceMixin on DatabaseAccessor<AppDatabase> {
  $CollectionTableTable get collectionTable => attachedDatabase.collectionTable;
  CollectionLocalDatasourceManager get managers =>
      CollectionLocalDatasourceManager(this);
}

class CollectionLocalDatasourceManager {
  final _$CollectionLocalDatasourceMixin _db;
  CollectionLocalDatasourceManager(this._db);
  $$CollectionTableTableTableManager get collectionTable =>
      $$CollectionTableTableTableManager(
        _db.attachedDatabase,
        _db.collectionTable,
      );
}
