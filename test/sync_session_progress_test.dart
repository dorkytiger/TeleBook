import 'package:flutter_test/flutter_test.dart';
import 'package:tele_book/feature/sync/service/sync_log_session.dart';
import 'package:tele_book/feature/sync/service/sync_mutation_service.dart';

void main() {
  test('SyncSessionProgress 汇总：当前书 + 总书籍进度', () {
    final session = SyncLogSession(id: 1, startedAt: DateTime.now());
    // 书一：同步中，5/10 图
    final b1 = session.book('b1', '书一');
    for (var i = 0; i < 10; i++) {
      b1.files['$i.jpg'] = i < 5 ? 'done' : 'pending';
    }
    b1.status = 'syncing';
    // 书二：已完成
    final b2 = session.book('b2', '书二');
    b2.files['a.jpg'] = 'done';
    b2.status = 'done';
    // 书三：等待中
    session.book('b3', '书三');

    // 手动执行 _updateSessionProgress 的等价逻辑（从会话推导）
    SyncLogSessionBook? current;
    for (final b in session.books) {
      if (b.status == 'syncing') { current = b; break; }
    }
    current ??= session.books
        .where((b) => b.status != 'done' && b.status != 'failed')
        .firstOrNull;

    expect(current?.name, '书一');
    expect(current?.filesDone, 5);
    expect(current?.filesTotal, 10);
    expect(session.syncedBooks, 1);
    expect(session.totalBooks, 3);
  });

  test('无 syncing 书时取第一个等待中的书', () {
    final session = SyncLogSession(id: 2, startedAt: DateTime.now());
    session.book('b3', '书三'); // 只有 pending

    SyncLogSessionBook? current;
    for (final b in session.books) {
      if (b.status == 'syncing') { current = b; break; }
    }
    current ??= session.books
        .where((b) => b.status != 'done' && b.status != 'failed')
        .firstOrNull;

    expect(current?.name, '书三');
    expect(current?.filesDone, 0);
  });
}
