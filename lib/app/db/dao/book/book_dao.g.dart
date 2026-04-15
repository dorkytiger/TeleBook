// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_dao.dart';

// ignore_for_file: type=lint
mixin _$BookDaoMixin on DatabaseAccessor<AppDatabase> {
  $BookTableTable get bookTable => attachedDatabase.bookTable;
  BookDaoManager get managers => BookDaoManager(this);
}

class BookDaoManager {
  final _$BookDaoMixin _db;
  BookDaoManager(this._db);
  $$BookTableTableTableManager get bookTable =>
      $$BookTableTableTableManager(_db.attachedDatabase, _db.bookTable);
}
