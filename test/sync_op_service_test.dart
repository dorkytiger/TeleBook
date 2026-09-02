import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/sync/datasource/sync_op_local_datasource.dart';
import 'package:tele_book/feature/sync/service/sync_op_service.dart';

void main() {
  test('队列串行：两个任务按顺序执行，状态正确', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final ops = SyncOpLocalDatasource(db);
    final svc = SyncOpService(ops);

    final order = <String>[];
    // 任务1
    final t1 = svc.enqueue(
      type: SyncOpType.refresh,
      executor: (cb, detail) async {
        order.add('t1-start');
        cb(const SyncOpProgress(currentBook: 1, totalBooks: 3, currentPage: 5, totalPages: 20));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        order.add('t1-end');
      },
    );
    // 任务2（任务1未完成时入队）
    final t2 = svc.enqueue(
      type: SyncOpType.refresh,
      executor: (cb, detail) async {
        order.add('t2-start');
        await Future<void>.delayed(const Duration(milliseconds: 20));
        order.add('t2-end');
      },
    );

    expect(svc.draining.value, isNotNull);
    // 等待两个任务完成
    await t1;
    await t2;
    // 稍等队列排空
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(order, ['t1-start', 't1-end', 't2-start', 't2-end']);
    // 两个任务都完成
    final all = await ops.listAll();
    expect(all.length, 2);
    expect(all.every((t) => t.status == SyncOpStatus.done), isTrue);
  });

  test('中断恢复：running 任务标记为 interrupted', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final ops = SyncOpLocalDatasource(db);
    final svc = SyncOpService(ops);

    // 插入一个 running 任务（模拟进程被杀遗留）
    final id = await ops.insertTask(type: SyncOpType.init, title: '初始化同步');
    await ops.updateTask(id, status: SyncOpStatus.running);

    await svc.recoverInterrupted();
    final t = await ops.listAll();
    expect(t.first.status, SyncOpStatus.interrupted);
  });

  test('失败任务：异常时标记 failed，不阻塞后续', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final ops = SyncOpLocalDatasource(db);
    final svc = SyncOpService(ops);

    final order = <String>[];
    await svc.enqueue(
      type: SyncOpType.refresh,
      executor: (cb, detail) async {
        throw StateError('模拟失败');
      },
    );
    await svc.enqueue(
      type: SyncOpType.refresh,
      executor: (cb, detail) async {
        order.add('after-fail');
      },
    );
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final all = await ops.listAll();
    // 第一个失败，第二个成功
    expect(all[0].status, SyncOpStatus.failed);
    expect(all[1].status, SyncOpStatus.done);
    expect(order, ['after-fail']);
  });

  test('会话内重试：失败任务重跑原执行器，成功即 done 且不再可重试', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final ops = SyncOpLocalDatasource(db);
    final svc = SyncOpService(ops);

    var attempts = 0;
    final id = await svc.enqueue(
      type: SyncOpType.refresh,
      executor: (cb, detail) async {
        attempts++;
        if (attempts == 1) throw StateError('第一次失败');
      },
    );
    await Future<void>.delayed(const Duration(milliseconds: 300));

    var all = await ops.listAll();
    expect(all.first.status, SyncOpStatus.failed);
    expect(await svc.canRetry(id), isTrue);

    // 重试 → 同一行从 failed 变 done，执行器重跑了一次
    await svc.retryTask(id);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    all = await ops.listAll();
    expect(all.length, 1, reason: '重试不应新增任务行');
    expect(all.first.status, SyncOpStatus.done);
    expect(attempts, 2);
    expect(await svc.canRetry(id), isFalse);
  });

  test('重启后（执行器不在内存）：失败任务不可重试，retry 为空操作', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final ops = SyncOpLocalDatasource(db);

    // 模拟上次进程遗留的 failed 任务
    final id = await ops.insertTask(type: SyncOpType.init, title: '初始化同步');
    await ops.updateTask(id, status: SyncOpStatus.failed, error: '遗留失败');

    // 新实例（无执行器内存表）
    final svc = SyncOpService(ops);
    expect(await svc.canRetry(id), isFalse);

    await svc.retryTask(id);
    final all = await ops.listAll();
    expect(all.first.status, SyncOpStatus.failed, reason: '无执行器时 retry 不应改状态');
  });

  test('重启恢复：retryWithExecutor 复用原行（中断→重跑→done，不新增行）', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final ops = SyncOpLocalDatasource(db);
    final svc = SyncOpService(ops);

    // 遗留中断的 push 任务（带规格）
    final id = await ops.insertTask(
      type: SyncOpType.push,
      title: '上传导入的书籍',
      payload: '{"opType":"import","items":[]}',
    );
    await ops.updateTask(id, status: SyncOpStatus.interrupted);
    expect((await svc.recoverablePushOps()).length, 1);

    var ran = 0;
    final scheduled = await svc.retryWithExecutor(id, (cb, detail) async {
      ran++;
    });
    expect(scheduled, isTrue);
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // 同一行从 interrupted → done，无新增行（通知因此不残留）
    final all = await ops.listAll();
    expect(all.length, 1, reason: '恢复不应新增任务行');
    expect(all.first.status, SyncOpStatus.done);
    expect(ran, 1);
    expect(await svc.recoverablePushOps(), isEmpty);

    // 已 done 的行不允许再次恢复调度
    expect(await svc.retryWithExecutor(id, (cb, detail) async {}), isFalse);
  });

  test('断点续传：重跑时 detail.resumeFrom = 行内已落库的 doneBooks（§8.2）', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final ops = SyncOpLocalDatasource(db);
    final svc = SyncOpService(ops);

    // 模拟上次执行到第 3 本时失败/中断（doneBooks 已落库）
    final id = await ops.insertTask(
      type: SyncOpType.push,
      title: '上传导入的书籍',
      totalBooks: 5,
      payload: '{"opType":"import","items":[]}',
    );
    await ops.updateTask(id,
        status: SyncOpStatus.failed, doneBooks: 3, totalBooks: 5, error: '中断');

    int? resumeFrom;
    final scheduled = await svc.retryWithExecutor(id, (cb, detail) async {
      resumeFrom = detail.resumeFrom;
    });
    expect(scheduled, isTrue);
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // 执行器应看到续传起点 = 3（从第 4 本继续，而不是从头）
    expect(resumeFrom, 3);
    final all = await ops.listAll();
    expect(all.single.status, SyncOpStatus.done);
    // 未重新上报进度时，落库的本数保持（不会被清零）
    expect(all.single.doneBooks, 3);
  });

  test('取消等待中任务：删除行；running 不可取消；同类型去重可见', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final ops = SyncOpLocalDatasource(db);
    final svc = SyncOpService(ops);

    // running 行不可取消
    final runningId = await ops.insertTask(
        type: SyncOpType.init, title: '初始化同步');
    await ops.updateTask(runningId, status: SyncOpStatus.running);
    expect(await svc.cancelTask(runningId), isFalse,
        reason: 'running 任务不可取消');

    // waiting 行（如误点的上传快照）可取消并删除
    final waitingId = await ops.insertTask(
        type: SyncOpType.uploadSnapshot, title: '上传快照');
    expect(await svc.hasActiveOfType(SyncOpType.uploadSnapshot), isTrue);
    expect(await svc.cancelTask(waitingId), isTrue);
    final all = await ops.listAll();
    expect(all.any((t) => t.id == waitingId), isFalse, reason: '取消后行已删除');
    expect(await svc.hasActiveOfType(SyncOpType.uploadSnapshot), isFalse);
    expect(await svc.cancelTask(waitingId), isFalse, reason: '重复取消返回 false');
  });

  test('组内明细写入：注册书→逐文件状态→整本收尾（§0 面板数据）', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final ops = SyncOpLocalDatasource(db);
    final svc = SyncOpService(ops);

    final w = svc.openDetailWriter(9); // 未入队也可直接测 writer 语义
    w.book('u1', '书A', ['cover.jpg', 'original/0000000.jpg', 'original/0000001.jpg']);
    var books = svc.detailOf(9);
    expect(books.length, 1);
    expect(books.single.files.length, 3);
    expect(books.single.status, 'syncing');

    // 逐文件推进：done / syncing / failed
    w.fileDone('u1', 'cover.jpg');
    w.fileSyncing('u1', 'original/0000000.jpg', progress: 0.4);
    w.fileFailed('u1', 'original/0000001.jpg', error: '网络错误');
    books = svc.detailOf(9);
    expect(books.single.status, 'failed', reason: '有失败页 → 书标 failed');
    expect(books.single.doneFiles, 1);
    expect(books.single.failedFiles, 1);

    // 页级重试补上失败页 → 书回 syncing（未全 done）
    w.fileSyncing('u1', 'original/0000001.jpg');
    w.fileDone('u1', 'original/0000001.jpg');
    w.fileDone('u1', 'original/0000000.jpg');
    books = svc.detailOf(9);
    expect(books.single.status, 'done');
    expect(books.single.doneFiles, 3);

    // 整本收尾：全部 done 保持 done
    w.finishBook('u1', ok: true);
    expect(svc.detailOf(9).single.status, 'done');
  });
}
