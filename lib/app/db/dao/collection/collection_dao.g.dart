// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_dao.dart';

// ignore_for_file: type=lint
mixin _$CollectionDaoMixin on DatabaseAccessor<AppDatabase> {
  $CollectionTableTable get collectionTable => attachedDatabase.collectionTable;
  CollectionDaoManager get managers => CollectionDaoManager(this);
}

class CollectionDaoManager {
  final _$CollectionDaoMixin _db;
  CollectionDaoManager(this._db);
  $$CollectionTableTableTableManager get collectionTable =>
      $$CollectionTableTableTableManager(
        _db.attachedDatabase,
        _db.collectionTable,
      );
}
