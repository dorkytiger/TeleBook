import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:tele_book/core/db/app_database.dart';

/// 构造 main 分支 v2 的真实库：只有 book_table（无 uuid 列）等业务表。
/// 验证 v2 → v3 增量升级：书库数据保留 + uuid 回填 + 新增同步表。
NativeDatabase _openV2Database() {
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
    'INSERT INTO "book_table" (name, local_sub_paths, current_page) VALUES (?, ?, ?)',
    ['旧书A', '[]', 3],
  );
  raw.execute(
    'INSERT INTO "book_table" (name, local_sub_paths) VALUES (?, ?)',
    ['旧书B', '[]'],
  );
  raw.execute('PRAGMA user_version = 2');
  return NativeDatabase.opened(raw);
}

void main() {
  test('v3 新库：同步队列/断点表齐全，sync_op 含 payload 列', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    for (final t in [
      'book_table',
      'sync_op_table',
      'sync_task_table',
      'sync_down_table',
      'sync_down_file_table',
      'sync_upload_table',
    ]) {
      final r = await db.customSelect(
        "SELECT name FROM sqlite_master WHERE type='table' AND name = ?",
        variables: [Variable(t)],
      ).getSingleOrNull();
      expect(r, isNotNull, reason: '$t 表应存在');
    }
    // 旧 sync_log（会话记录）已删除
    final log = await db.customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='sync_log_table'",
    ).getSingleOrNull();
    expect(log, isNull, reason: 'sync_log_table 应不存在');

    // sync_op.payload 列存在且可读写（组任务规格落库）
    await db.customInsert(
      'INSERT INTO sync_op_table (type, title, status, payload, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?)',
      variables: [
        Variable('push'), Variable('上传导入的书籍'), Variable('running'),
        Variable('{"opType":"import","items":[]}'),
        Variable(DateTime.now()), Variable(DateTime.now()),
      ],
    );
    final row = await db
        .customSelect(
          'SELECT type, payload FROM sync_op_table WHERE type = ?',
          variables: [Variable('push')],
        )
        .getSingle();
    expect(row.data['payload'], '{"opType":"import","items":[]}');
  });

  test('v2(main) → v3：保留书库数据，book 加 uuid 回填，新增同步表', () async {
    final db = AppDatabase(_openV2Database());
    addTearDown(db.close);

    // ① 旧书数据保留（增量升级不清库）
    final books = await db
        .customSelect('SELECT id, name, current_page FROM book_table ORDER BY id')
        .get();
    expect(books.length, 2, reason: '旧书应保留');
    expect(books[0].data['name'], '旧书A');
    expect(books[0].data['current_page'], 3);

    // ② book_table.uuid 已回填：5 段格式且唯一
    final uuids = await db
        .customSelect('SELECT uuid FROM book_table ORDER BY id')
        .get();
    for (final row in uuids) {
      final uuid = row.data['uuid'] as String?;
      expect(uuid, isNotNull);
      expect(uuid!.isNotEmpty, isTrue);
      expect(uuid.split('-').length, 5, reason: 'uuid 应为 5 段');
    }
    expect(uuids[0].data['uuid'], isNot(uuids[1].data['uuid']), reason: 'uuid 唯一');
    final index = await db.customSelect(
      "SELECT name FROM sqlite_master WHERE type='index' AND name='book_table_uuid_key'",
    ).getSingleOrNull();
    expect(index, isNotNull, reason: '应存在 uuid 唯一索引');

    // ③ v3 新增的表齐全
    for (final t in [
      'setting_table',
      'entity_sync_state_table',
      'sync_task_table',
      'sync_op_table',
      'sync_down_table',
      'sync_down_file_table',
      'sync_upload_table',
    ]) {
      final r = await db.customSelect(
        "SELECT name FROM sqlite_master WHERE type='table' AND name = ?",
        variables: [Variable(t)],
      ).getSingleOrNull();
      expect(r, isNotNull, reason: '$t 表应在 v2→v3 升级后存在');
    }

    // ④ 新表可写（sync_op 含 payload）
    await db.customInsert(
      'INSERT INTO sync_op_table (type, title, status, payload, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?)',
      variables: [
        Variable('push'), Variable('上传导入的书籍'), Variable('running'),
        Variable('{"opType":"import","items":[]}'),
        Variable(DateTime.now()), Variable(DateTime.now()),
      ],
    );
    final row = await db
        .customSelect('SELECT payload FROM sync_op_table WHERE type = ?',
            variables: [Variable('push')])
        .getSingle();
    expect(row.data['payload'], '{"opType":"import","items":[]}');
  });

  test('sync_op 队列表可用：状态/进度读写', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await db.customInsert(
      'INSERT INTO sync_op_table (type, title, status, total_books, done_books, current_page, total_pages, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      variables: [
        Variable('init'), Variable('初始化同步'), Variable('running'),
        Variable(5), Variable(2), Variable(10), Variable(30),
        Variable(DateTime.now()), Variable(DateTime.now()),
      ],
    );
    final row = await db
        .customSelect('SELECT status, done_books, total_pages FROM sync_op_table')
        .getSingle();
    expect(row.data['status'], 'running');
    expect(row.data['done_books'], 2);
    expect(row.data['total_pages'], 30);
  });

  test('sync_down/sync_upload 断点表可用', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await db.customInsert(
      'INSERT INTO sync_down_table (uuid, name, total_files, done_files, status, book_status, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      variables: [Variable('u1'), Variable('书A'), Variable(38), Variable(5),
                  Variable('downloading'), Variable('下载中'), Variable(DateTime.now()), Variable(DateTime.now())],
    );
    final row = await db.customSelect('SELECT name, done_files FROM sync_down_table WHERE uuid = ?',
      variables: [Variable('u1')]).getSingle();
    expect(row.data['name'], '书A');
    expect(row.data['done_files'], 5);
  });
}
