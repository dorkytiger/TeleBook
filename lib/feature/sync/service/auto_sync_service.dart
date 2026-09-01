import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/feature/sync/service/sync_mutation_service.dart';
import 'package:tele_book/feature/sync/ui/provider/sync_status_provider.dart';

/// 自动同步：启动即 drain（推送 outbox）+ pull 一次，之后每 5 分钟执行。
///
/// 本地变更已实时入 outbox 并立即 drain；这里负责周期性的补漏与拉取远端变更。
class AutoSyncService {
  static const interval = Duration(minutes: 5);

  final Ref ref;
  Timer? _timer;

  AutoSyncService(this.ref);

  void start() {
    _timer ??= Timer.periodic(interval, (_) => run());
    run();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> run() async {
    final mutation = ref.read(syncMutationServiceProvider);
    if (!await mutation.isConfigured()) return;
    final status = ref.read(syncStatusProvider.notifier);
    status.setSyncing(true);
    var ok = true;
    try {
      await mutation.beginSyncSession(); // 本地同步记录：会话开始
      await mutation.drain(); // 推送待同步任务（outbox；失败内部已上报）
      // 拉取远端变更：每本书的图片下载进度实时上报底栏 + 同步记录
      var doneBooks = 0;
      final countedBooks = <String>{};
      status.setSyncDetail('同步中 · 拉取变更…');
      await ref.read(syncServiceProvider.notifier).pullOnly(
        onBookDownload: (uuid, name, done, total) {
          mutation.sessionReportBookAggregate(uuid, name, done, total);
          if (total > 0 && done >= total && countedBooks.add(uuid)) {
            doneBooks++;
          }
          status.setSyncDetail(
            done >= total
                ? '同步中 · 已完成 $doneBooks 本'
                : '同步中 · 当前 $name $done/$total · 已完成 $doneBooks 本',
          );
        },
      );
      await ref.read(syncStatusProvider.notifier).refresh();
    } catch (e) {
      // 拉取失败：弹窗提示（网络恢复后下个周期自动重试）
      ok = false;
      mutation.reportError('同步失败: $e');
    } finally {
      await mutation.endSyncSession(ok: ok);
      status.setSyncDetail(null);
      status.setSyncing(false);
    }
  }
}

final autoSyncServiceProvider = Provider<AutoSyncService>((ref) {
  final service = AutoSyncService(ref);
  service.start();
  ref.onDispose(service.stop);
  return service;
});
