import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:tele_book/core/db/app_database.dart';

/// 构造一个 v3 schema 的内存库（book_table 无 uuid 列），
/// 返回可直接传给 AppDatabase 的已打开连接。
NativeDatabase _openV3Database() {
  final raw = sqlite.sqlite3.openInMemory();
  raw.execute('''
    CREATE TABLE "book_table" (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      "name" TEXT NOT NULL,
      "local_sub_paths" TEXT NOT NULL,
      "cover_sub_path" TEXT,
      "preview_sub_paths" TEXT,
      "read_count" INTEGER NOT NULL DEFAULT 0,
      "current_page" INTEGER NOT NULL DEFAULT 0,
      "created_at" INTEGER NOT NULL DEFAULT 0
    )
  ''');
  raw.execute(
    'INSERT INTO "book_table" (name, local_sub_paths) VALUES (?, ?)',
    ['旧书A', '[]'],
  );
  raw.execute(
    'INSERT INTO "book_table" (name, local_sub_paths) VALUES (?, ?)',
    ['旧书B', '[]'],
  );
  raw.execute('PRAGMA user_version = 3');
  return NativeDatabase.opened(raw);
}

void main() {
  test('v3 → v6 真实迁移：加 uuid 列并回填唯一值', () async {
    final db = AppDatabase(_openV3Database());
    addTearDown(db.close);

    // 迁移后 books 表应含 uuid 列，且旧数据全部回填
    final rows = await db
        .customSelect('SELECT uuid, name FROM book_table ORDER BY id')
        .get();
    expect(rows.length, 2);
    final uuids = rows.map((r) => r.data['uuid'] as String).toList();
    for (final uuid in uuids) {
      expect(uuid, isNotEmpty);
      expect(uuid.split('-').length, 5, reason: 'uuid 应为 5 段格式');
    }
    // 唯一性：两本书 uuid 不同
    expect(uuids[0], isNot(uuids[1]));

    // uuid 列上有唯一索引（SQLite 不允许 ALTER 加 NOT NULL UNIQUE 列，
    // 迁移用可空列 + 回填 + 唯一索引实现）
    final index = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type='index' AND name='book_table_uuid_key'",
        )
        .getSingleOrNull();
    expect(index, isNotNull, reason: '应存在 uuid 唯一索引');
  });

  test('v3 → v6 真实迁移：新增的同步相关表存在且可用', () async {
    final db = AppDatabase(_openV3Database());
    addTearDown(db.close);

    // entity_sync_state 表可读写
    await db.customInsert(
      'INSERT INTO entity_sync_state_table (entity_type, entity_id, server_revision) VALUES (?, ?, ?)',
      variables: [Variable('book'), Variable('uuid-001'), Variable(3)],
    );
    final rev = await db
        .customSelect(
          'SELECT server_revision FROM entity_sync_state_table WHERE entity_id = ?',
          variables: [Variable('uuid-001')],
        )
        .getSingle();
    expect(rev.data['server_revision'], 3);

    // sync_task（outbox）与 sync_log 表存在
    for (final table in ['sync_task_table', 'sync_log_table']) {
      final t = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name = ?",
            variables: [Variable(table)],
          )
          .getSingleOrNull();
      expect(t, isNotNull, reason: '$table 表应存在');
    }
  });

  test('v4 schema：books 表含 uuid 列，entity_sync_state 表存在', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    // books 表带 uuid 插入
    await db.customInsert(
      'INSERT INTO book_table (uuid, name, local_sub_paths) VALUES (?, ?, ?)',
      variables: [Variable('uuid-001'), Variable('测试书'), Variable('[]')],
    );
    final row = await db
        .customSelect(
          'SELECT uuid, name FROM book_table WHERE uuid = ?',
          variables: [Variable('uuid-001')],
        )
        .getSingle();
    expect(row.data['uuid'], 'uuid-001');
    expect(row.data['name'], '测试书');

    // entity_sync_state 表已创建
    final syncTable = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='entity_sync_state_table'",
        )
        .getSingleOrNull();
    expect(syncTable, isNotNull);

    // sync 状态表可读写
    await db.customInsert(
      'INSERT INTO entity_sync_state_table (entity_type, entity_id, server_revision) VALUES (?, ?, ?)',
      variables: [Variable('book'), Variable('uuid-001'), Variable(3)],
    );
    final rev = await db
        .customSelect(
          'SELECT server_revision FROM entity_sync_state_table WHERE entity_id = ?',
          variables: [Variable('uuid-001')],
        )
        .getSingle();
    expect(rev.data['server_revision'], 3);
  });
}
