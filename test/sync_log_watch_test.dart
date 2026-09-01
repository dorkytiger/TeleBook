import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/sync/model/table/sync_log_table.dart';

void main() {
  test('watchLog 实时响应数据库更新', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final id = await db.into(db.syncLogTable).insert(
      SyncLogTableCompanion.insert(startedAt: DateTime.now(), status: 'running'),
    );

    final seen = <String>[];
    final sub = (db.select(db.syncLogTable)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .listen((row) {
      seen.add(row?.status ?? 'null');
    });
    // 等待首次 emit
    await Future<void>.delayed(const Duration(milliseconds: 100));

    // 模拟会话期间进度更新（每 100ms 写一次）
    await db.update(db.syncLogTable).write(
      const SyncLogTableCompanion(
        status: Value('running'),
        totalBooks: Value(1),
        syncedBooks: Value(0),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await db.update(db.syncLogTable).write(
      const SyncLogTableCompanion(
        status: Value('completed'),
        totalBooks: Value(1),
        syncedBooks: Value(1),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 150));

    await sub.cancel();
    expect(seen, contains('running'));
    expect(seen, contains('completed'));
    expect(seen.length, greaterThanOrEqualTo(3), reason: '应观察到多次更新: $seen');
  });
}
