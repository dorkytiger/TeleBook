// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_book_dao.dart';

// ignore_for_file: type=lint
mixin _$MarkBookDaoMixin on DatabaseAccessor<AppDatabase> {
  $MarkTableTable get markTable => attachedDatabase.markTable;
  $BookTableTable get bookTable => attachedDatabase.bookTable;
  $MarkBookTableTable get markBookTable => attachedDatabase.markBookTable;
  MarkBookDaoManager get managers => MarkBookDaoManager(this);
}

class MarkBookDaoManager {
  final _$MarkBookDaoMixin _db;
  MarkBookDaoManager(this._db);
  $$MarkTableTableTableManager get markTable =>
      $$MarkTableTableTableManager(_db.attachedDatabase, _db.markTable);
  $$BookTableTableTableManager get bookTable =>
      $$BookTableTableTableManager(_db.attachedDatabase, _db.bookTable);
  $$MarkBookTableTableTableManager get markBookTable =>
      $$MarkBookTableTableTableManager(_db.attachedDatabase, _db.markBookTable);
}
