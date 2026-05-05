// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_local_datasource.dart';

// ignore_for_file: type=lint
mixin _$BookLocalDatasourceMixin on DatabaseAccessor<AppDatabase> {
  $BookTableTable get bookTable => attachedDatabase.bookTable;
  BookLocalDatasourceManager get managers => BookLocalDatasourceManager(this);
}

class BookLocalDatasourceManager {
  final _$BookLocalDatasourceMixin _db;
  BookLocalDatasourceManager(this._db);
  $$BookTableTableTableManager get bookTable =>
      $$BookTableTableTableManager(_db.attachedDatabase, _db.bookTable);
}
