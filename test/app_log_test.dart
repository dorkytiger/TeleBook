import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:tele_book/core/util/app_log.dart';

/// 日志系统健壮性测试：滚动、环形缓冲、崩溃记录、超龄清理、总量预算。
void main() {
  late Directory tmp;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('applog_test');
  });

  tearDown(() async {
    try {
      await tmp.delete(recursive: true);
    } catch (_) {}
  });

  test('初始化后日志落盘，readTail 读到写入行', () async {
    await AppLog.initForTest(tmp.path);
    AppLog.i('hello 落盘', tag: 'T');
    await AppLog.flushNow();

    final lines = await AppLog.readTail();
    expect(lines.any((l) => l.contains('hello 落盘') && l.contains('[T]')),
        isTrue);
  });

  test('滚动：写超单文件上限后产生 app.1.log，主文件归零', () async {
    await AppLog.initForTest(tmp.path);
    // 分批写入并落盘（洪峰保护会丢弃超积压的旧行，故每批都 flush 一次）
    // 每行 ~110 字节 × 20000 行 ≈ 2.2MB > 2MB 单文件上限，触发滚动
    for (var batch = 0; batch < 20; batch++) {
      for (var i = 0; i < 1000; i++) {
        AppLog.i('padding line $batch-$i ${'x' * 80}', tag: 'ROLL');
      }
      await AppLog.flushNow();
    }

    final dir = Directory(AppLog.dirPath!);
    final logs = dir
        .listSync()
        .whereType<File>()
        .where((f) => p.basename(f.path).startsWith('app'))
        .toList();
    expect(logs.length, lessThanOrEqualTo(AppLog.maxFiles),
        reason: '滚动份数不得超过上限');
    // 至少发生过一次滚动（有 app.1.log）
    final rotated = dir
        .listSync()
        .whereType<File>()
        .where((f) => p.basename(f.path) == 'app.1.log')
        .toList();
    expect(rotated, isNotEmpty);
  });

  test('环形缓冲保留最近 ringSize 行（崩溃现场）', () async {
    await AppLog.initForTest(tmp.path);
    final total = AppLog.ringSize + 50;
    for (var i = 0; i < total; i++) {
      AppLog.i('ring line $i', tag: 'R');
    }
    final ring = AppLog.ringTail();
    expect(ring.length, AppLog.ringSize);
    // 共 total 行，保留最后 ringSize 行 → 第一行是 index = total - ringSize = 50
    expect(ring.first.contains('ring line 50'), isTrue,
        reason: '最早的 50 行应被淘汰');
    expect(ring.last.contains('ring line ${total - 1}'), isTrue);
  });

  test('writeCrash 落盘崩溃文件并带环形缓冲现场', () async {
    await AppLog.initForTest(tmp.path);
    for (var i = 0; i < 5; i++) {
      AppLog.i('现场 $i', tag: 'SCENE');
    }
    final f = await AppLog.writeCrash(
      title: '测试崩溃',
      stack: 'line1\nline2',
      contextHeader: 'App: 1.0 (1)\n平台: android',
    );
    expect(f, isNotNull);
    expect(await f!.exists(), isTrue);
    final content = await f.readAsString();
    expect(content, contains('测试崩溃'));
    expect(content, contains('line2'));
    expect(content, contains('现场 4'));
    expect(await AppLog.crashCount(), greaterThanOrEqualTo(1));
  });

  test('超龄崩溃文件被清理（时间维度兜底）', () async {
    await AppLog.initForTest(tmp.path);
    // 手工伪造一份 40 天前的崩溃文件
    final oldMs = DateTime.now()
        .subtract(const Duration(days: 40))
        .millisecondsSinceEpoch;
    final old = File(p.join(AppLog.dirPath!, 'crash_$oldMs.log'));
    await old.writeAsString('旧崩溃');

    // 再写一份新的
    await AppLog.writeCrash(title: '新崩溃', stack: 's', contextHeader: 'h');

    await AppLog.maintenance();
    expect(await old.exists(), isFalse, reason: '超 30 天崩溃应被清理');
    final crashes = await AppLog.crashFiles();
    expect(crashes.length, 1);
    expect((await crashes.first.readAsString()).contains('新崩溃'), isTrue);
  });

  test('崩溃文件超过保留份数时删最旧', () async {
    await AppLog.initForTest(tmp.path);
    for (var i = 0; i < AppLog.crashKeep + 3; i++) {
      await AppLog.writeCrash(
        title: '崩溃 $i',
        stack: 's',
        contextHeader: 'h',
      );
    }
    expect(await AppLog.crashCount(), AppLog.crashKeep);
  });

  test('总量预算：超限后删最旧文件', () async {
    await AppLog.initForTest(tmp.path);
    // 伪造大量旧崩溃文件占满预算
    final past = DateTime.now()
        .subtract(const Duration(days: 5))
        .millisecondsSinceEpoch;
    var total = 0;
    for (var i = 0; i < 60; i++) {
      final f = File(p.join(AppLog.dirPath!, 'crash_${past + i * 1000}.log'));
      await f.writeAsBytes(List.filled(256 * 1024, 0x61)); // 每个 256KB
      total += 256 * 1024;
    }
    expect(total, greaterThan(AppLog.totalBudgetBytes));

    await AppLog.maintenance();
    // 预算执行后目录总大小应低于预算（留有 app.log 余量）
    final dir = Directory(AppLog.dirPath!);
    var sum = 0;
    for (final f in dir.listSync().whereType<File>()) {
      sum += f.lengthSync();
    }
    expect(sum, lessThanOrEqualTo(AppLog.totalBudgetBytes));
  });

  test('clear 清空主日志但保留崩溃记录', () async {
    await AppLog.initForTest(tmp.path);
    AppLog.i('将被清空', tag: 'C');
    await AppLog.flushNow();
    await AppLog.writeCrash(title: '保留', stack: 's', contextHeader: 'h');

    await AppLog.clear();
    final lines = await AppLog.readTail();
    expect(lines.any((l) => l.contains('将被清空')), isFalse);
    expect(await AppLog.crashCount(), greaterThanOrEqualTo(1));
  });
}
