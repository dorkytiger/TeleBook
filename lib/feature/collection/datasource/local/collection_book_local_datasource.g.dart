// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_book_local_datasource.dart';

// ignore_for_file: type=lint
mixin _$CollectionBookLocalDatasourceMixin on DatabaseAccessor<AppDatabase> {
  $CollectionBookTableTable get collectionBookTable =>
      attachedDatabase.collectionBookTable;
  CollectionBookLocalDatasourceManager get managers =>
      CollectionBookLocalDatasourceManager(this);
}

class CollectionBookLocalDatasourceManager {
  final _$CollectionBookLocalDatasourceMixin _db;
  CollectionBookLocalDatasourceManager(this._db);
  $$CollectionBookTableTableTableManager get collectionBookTable =>
      $$CollectionBookTableTableTableManager(
        _db.attachedDatabase,
        _db.collectionBookTable,
      );
}
