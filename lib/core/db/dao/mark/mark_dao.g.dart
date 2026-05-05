// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_dao.dart';

// ignore_for_file: type=lint
mixin _$MarkDaoMixin on DatabaseAccessor<AppDatabase> {
  $MarkTableTable get markTable => attachedDatabase.markTable;
  MarkDaoManager get managers => MarkDaoManager(this);
}

class MarkDaoManager {
  final _$MarkDaoMixin _db;
  MarkDaoManager(this._db);
  $$MarkTableTableTableManager get markTable =>
      $$MarkTableTableTableManager(_db.attachedDatabase, _db.markTable);
}
