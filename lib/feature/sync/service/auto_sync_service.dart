import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/feature/sync/service/sync_mutation_service.dart';

/// 自动同步：启动即 drain（推送 outbox）+ pull 一次，之后每 5 分钟执行。
///
/// 本地变更已实时入 outbox 并立即 drain；这里负责周期性的补漏与拉取远端变更。
///
/// 状态通过 [syncing] / [syncDetail] / [refreshTick] 三个 ValueNotifier 对外暴露，
/// 由 `SyncStatusNotifier` 单向监听更新底栏 —— 避免反向 read provider 造成循环依赖。
class AutoSyncService {
  static const interval = Duration(minutes: 5);

  final Ref ref;
  Timer? _timer;

  /// 自动同步是否进行中（SyncStatusNotifier 监听）。
  final ValueNotifier<bool> syncing = ValueNotifier(false);

  /// 同步中实时文案（如"当前 书X 13/20 · 已完成 1 本"）。
  final ValueNotifier<String?> syncDetail = ValueNotifier(null);

  /// 每次同步周期完成后 +1（SyncStatusNotifier 监听后刷新配置/待同步数/冲突数）。
  final ValueNotifier<int> refreshTick = ValueNotifier(0);

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
    syncing.value = true;
    var ok = true;
    try {
      await mutation.beginSyncSession(); // 本地同步记录：会话开始
      await mutation.drain(); // 推送待同步任务（outbox；失败内部已上报）
      // 拉取远端变更：每本书的图片下载进度实时上报底栏 + 同步记录
      var doneBooks = 0;
      var failedFiles = 0;
      final countedBooks = <String>{};
      syncDetail.value = '同步中 · 拉取变更…';
      await ref.read(syncServiceProvider.notifier).pullOnly(
        onBookDownload: (uuid, name, done, total) {
          mutation.sessionReportBookAggregate(uuid, name, done, total);
          if (total > 0 && done >= total && countedBooks.add(uuid)) {
            doneBooks++;
          }
          syncDetail.value = done >= total
              ? '同步中 · 已完成 $doneBooks 本'
              : '同步中 · 当前 $name $done/$total · 已完成 $doneBooks 本';
        },
        onBookFileError: (uuid, relPath, error) {
          failedFiles++;
        },
      );
      if (failedFiles > 0) {
        // 游标未推进：下个周期会自动补下失败图片
        mutation.reportError('有 $failedFiles 张图片下载失败，将在下次自动同步时重试');
      }
      refreshTick.value++; // 通知 SyncStatusNotifier 刷新
    } catch (e) {
      // 拉取失败：弹窗提示（网络恢复后下个周期自动重试）
      ok = false;
      mutation.reportError('同步失败: $e');
    } finally {
      await mutation.endSyncSession(ok: ok);
      syncDetail.value = null;
      syncing.value = false;
    }
  }
}

final autoSyncServiceProvider = Provider<AutoSyncService>((ref) {
  final service = AutoSyncService(ref);
  service.start();
  ref.onDispose(service.stop);
  return service;
});
