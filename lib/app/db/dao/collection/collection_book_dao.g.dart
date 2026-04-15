// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_book_dao.dart';

// ignore_for_file: type=lint
mixin _$CollectionBookDaoMixin on DatabaseAccessor<AppDatabase> {
  $BookTableTable get bookTable => attachedDatabase.bookTable;
  $CollectionTableTable get collectionTable => attachedDatabase.collectionTable;
  $CollectionBookTableTable get collectionBookTable =>
      attachedDatabase.collectionBookTable;
  CollectionBookDaoManager get managers => CollectionBookDaoManager(this);
}

class CollectionBookDaoManager {
  final _$CollectionBookDaoMixin _db;
  CollectionBookDaoManager(this._db);
  $$BookTableTableTableManager get bookTable =>
      $$BookTableTableTableManager(_db.attachedDatabase, _db.bookTable);
  $$CollectionTableTableTableManager get collectionTable =>
      $$CollectionTableTableTableManager(
        _db.attachedDatabase,
        _db.collectionTable,
      );
  $$CollectionBookTableTableTableManager get collectionBookTable =>
      $$CollectionBookTableTableTableManager(
        _db.attachedDatabase,
        _db.collectionBookTable,
      );
}
