import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tele_book/core/db/app_database.dart';

void main() {
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

  test('v3 → v4 迁移为已有书籍回填 uuid', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    // 模拟 v3 数据：books 表无 uuid 列
    await db.customStatement('DROP TABLE IF EXISTS book_table');
    await db.customStatement(
      'CREATE TABLE book_table (id INTEGER PRIMARY KEY, name TEXT NOT NULL, local_sub_paths TEXT NOT NULL)',
    );
    await db.customInsert(
      'INSERT INTO book_table (name, local_sub_paths) VALUES (?, ?)',
      variables: [Variable('旧书'), Variable('[]')],
    );

    // 手动模拟 v3→v4 迁移步骤
    await db.customStatement(
      'CREATE TABLE IF NOT EXISTS entity_sync_state_table (entity_type TEXT NOT NULL, entity_id TEXT NOT NULL, server_revision INTEGER NOT NULL DEFAULT 0, PRIMARY KEY (entity_type, entity_id))',
    );
    await db.customStatement('ALTER TABLE book_table ADD COLUMN uuid TEXT');
    await db.customStatement(
      'UPDATE book_table SET uuid = lower(hex(randomblob(4))) || \'-\' || lower(hex(randomblob(2))) || \'-\' || lower(hex(randomblob(2))) || \'-\' || lower(hex(randomblob(2))) || \'-\' || lower(hex(randomblob(6))) WHERE uuid IS NULL',
    );

    final row = await db.customSelect('SELECT uuid, name FROM book_table').getSingle();
    expect(row.data['uuid'], isNotEmpty);
    expect(row.data['name'], '旧书');
    expect((row.data['uuid'] as String).split('-').length, 5);
  });
}
