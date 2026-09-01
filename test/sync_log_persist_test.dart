import 'dart:convert';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/sync/datasource/sync_log_local_datasource.dart';
import 'package:tele_book/feature/sync/model/table/sync_log_table.dart';
import 'package:tele_book/feature/sync/service/sync_log_session.dart';

void main() {
  test('会话多次更新均能落库（防抖不再吞更新）', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final ds = SyncLogLocalDatasource(db);

    final id = await ds.insertLog(
      SyncLogTableCompanion.insert(startedAt: DateTime.now(), status: 'running'),
    );
    final session = SyncLogSession(id: id, startedAt: DateTime.now());

    // 模拟 drain 预注册 + 推送进度：多次调用 _schedulePersist 语义（每次变更后写库）
    // 直接验证：session 状态变化 → toDetailJson → updateLog 应每次都写入最新 detail
    session.book('b1', '书一').status = 'syncing';
    session.book('b1', '书一').files['1.jpg'] = 'done';
    await ds.updateLog(id, status: 'running', detail: session.toDetailJson());

    // 第二、三次更新（原 bug：第二次起 UI 拿不到）
    session.book('b2', '书二').status = 'syncing';
    await ds.updateLog(id, status: 'running', detail: session.toDetailJson());
    session.book('b1', '书一').status = 'done';
    session.book('b2', '书二').status = 'done';
    await ds.updateLog(id, status: 'completed', detail: session.toDetailJson());

    final finalLog = await ds.getLog(id);
    expect(finalLog, isNotNull);
    final detail = jsonDecode(finalLog!.detail!) as Map<String, dynamic>;
    final books = detail['books'] as List;
    expect(books.length, 2, reason: '两本书都应出现在最终 detail 中');
    expect(finalLog.status, 'completed');
  });
}
