import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tele_book/feature/sync/service/sync_queue.dart';

void main() {
  test('SyncQueue 串行执行：任务不会并发重叠', () async {
    final queue = SyncQueue();
    final order = <String>[];
    final gate = Completer<void>();

    final f1 = queue.enqueue(() async {
      order.add('t1-start');
      await gate.future; // 阻塞直到放行
      order.add('t1-end');
    });
    // 等 t1 进入执行（持有锁）
    await Future<void>.delayed(const Duration(milliseconds: 50));
    final f2 = queue.enqueue(() async {
      order.add('t2');
    });

    expect(order, ['t1-start'], reason: 't2 必须等 t1 完成后才能开始');

    gate.complete();
    await Future.wait([f1, f2]);
    expect(order, ['t1-start', 't1-end', 't2']);
  });

  test('SyncQueue 错误传播：任务抛错 → Future 以错误结束，后续任务继续', () async {
    final queue = SyncQueue();
    var ran = false;

    await expectLater(
      queue.enqueue(() async => throw StateError('boom')),
      throwsStateError,
    );

    await queue.enqueue(() async {
      ran = true;
    });
    expect(ran, isTrue, reason: '失败任务不应阻塞后续任务');
  });

  test('SyncQueue 入队顺序 FIFO', () async {
    final queue = SyncQueue();
    final order = <int>[];
    await Future.wait([
      queue.enqueue(() async => order.add(1)),
      queue.enqueue(() async => order.add(2)),
      queue.enqueue(() async => order.add(3)),
    ]);
    expect(order, [1, 2, 3]);
  });
}
