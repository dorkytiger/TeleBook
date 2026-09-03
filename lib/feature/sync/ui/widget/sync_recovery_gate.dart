import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:tele_book/common/widget/f_adaptive_dialog.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/util/app_log.dart';
import 'package:tele_book/feature/sync/datasource/sync_op_local_datasource.dart';
import 'package:tele_book/feature/sync/datasource/sync_upload_local_datasource.dart';
import 'package:tele_book/feature/sync/service/init_sync_service.dart';
import 'package:tele_book/feature/sync/service/optimistic_download_service.dart';
import 'package:tele_book/feature/sync/service/sync_mutation_service.dart';
import 'package:tele_book/feature/sync/service/sync_op_service.dart';

/// 启动恢复提示（§8.0）：进程重启后，若上次同步有未完成/中断残留，弹一次
/// 对话框询问「是否继续」。按残留类型给出动作：
/// - 继续推送 → 重启遗留的中断 push 任务按 payload 重建（内容型变更）
/// - 继续恢复 → 断点续传（sync_down 缺页 + sync_upload 残留，组任务 resume）
/// - 重新同步 → 重跑「刷新同步」（全量，幂等）
/// - 忽略 → 本次启动不再打扰
class SyncRecoveryGate extends ConsumerStatefulWidget {
  const SyncRecoveryGate({super.key});

  @override
  ConsumerState<SyncRecoveryGate> createState() => _SyncRecoveryGateState();
}

class _SyncRecoveryGateState extends ConsumerState<SyncRecoveryGate> {
  static bool _promptShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _probe());
  }

  Future<void> _probe() async {
    if (_promptShown || !mounted) return;
    final mutation = ref.read(syncMutationServiceProvider);
    if (!await mutation.isConfigured()) return;
    // 等队列/数据库就绪
    await Future<void>.delayed(const Duration(milliseconds: 300));
    // 补推上次进程遗留的静默进度（成功即清，失败保留）
    await mutation.flushProgress();

    final ops = ref.read(syncOpServiceProvider);
    final downloader = ref.read(optimisticDownloadServiceProvider);
    // iOS 后台下载兜底：进程被杀时系统仍可能完成了下载 → 先标记为 done
    await downloader.reconcileBackgroundDownloads();
    final downCount = (await downloader.unfinishedDownloads()).length;
    final uploadCount =
        (await ref.read(syncUploadLocalDatasourceProvider).listAll()).length;
    final pushRows = await ops.recoverablePushOps();
    final interrupted = await ops.countInterrupted();
    final otherInterrupted = interrupted -
        pushRows.where((r) => r.status == SyncOpStatus.interrupted).length;
    if (downCount + uploadCount + otherInterrupted == 0 && pushRows.isEmpty) {
      return;
    }
    if (!mounted) return;

    _promptShown = true;
    final lines = <String>[
      if (downCount > 0) '· 有 $downCount 本书还有页未下载完成',
      if (uploadCount > 0) '· 有 $uploadCount 本书上传中断',
      if (pushRows.isNotEmpty) '· 有 ${pushRows.length} 个本地变更推送未完成',
      if (otherInterrupted > 0) '· 有 $otherInterrupted 个同步任务中断',
    ];
    await showFDialog<void>(
      context: context,
      builder: (dialogContext, style, animate) => FAdaptiveDialog(
        title: const Text('上次同步未完成'),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('检测到上次同步中断：', style: style.bodyTextStyle),
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(line, style: style.bodyTextStyle),
              ),
            const SizedBox(height: 4),
            Text('可选择继续上次的同步，或忽略。', style: style.bodyTextStyle),
          ],
        ),
        actions: [
          if (pushRows.isNotEmpty)
            FButton(
              size: .sm,
              onPress: () async {
                Navigator.pop(dialogContext);
                await _resumePush(pushRows);
              },
              child: const Text('继续推送'),
            ),
          if (otherInterrupted > 0)
            FButton(
              variant: .outline,
              size: .sm,
              onPress: () async {
                Navigator.pop(dialogContext);
                await _rerunRefresh();
              },
              child: const Text('重新同步'),
            ),
          if (downCount + uploadCount > 0)
            FButton(
              variant: .outline,
              size: .sm,
              onPress: () async {
                Navigator.pop(dialogContext);
                await _resume();
              },
              child: const Text('继续恢复'),
            ),
          FButton(
            variant: .ghost,
            size: .sm,
            onPress: () => Navigator.pop(dialogContext),
            child: const Text('忽略'),
          ),
        ],
      ),
    );
  }

  Future<void> _resumePush(List<SyncOpTableData> rows) async {
    final mutation = ref.read(syncMutationServiceProvider);
    var ok = 0;
    for (final row in rows) {
      try {
        if (await mutation.enqueuePushFromPayload(row)) {
          ok++;
        }
      } catch (e) {
        AppLog.w('恢复推送失败 ${row.id}: $e', tag: 'RECOVERY');
      }
    }
    if (!mounted) return;
    showFToast(
      context: context,
      title: Text(ok > 0 ? '已重新加入 $ok 个变更推送' : '恢复失败，请稍后再试'),
    );
  }

  Future<void> _resume() async {
    // 旧 interrupted 行已被"继续恢复"接管（resume 组任务新建行）→ 清掉，
    // 避免历史中断行残留导致底部通知不清
    await _clearInterruptedRows();
    try {
      await ref.read(initSyncServiceProvider).resumeUnfinished();
      if (mounted) {
        showFToast(context: context, title: const Text('已开始恢复上次同步'));
      }
    } catch (e) {
      if (mounted) {
        showFToast(
          context: context,
          title: const Text('恢复失败'),
          description: Text('$e'),
        );
      }
    }
  }

  Future<void> _rerunRefresh() async {
    // 旧 interrupted 行（init/refresh/resume 等）被"重新同步"接管 → 清掉，
    // 避免历史中断行残留导致底部通知不清
    await _clearInterruptedRows();
    try {
      await ref.read(initSyncServiceProvider).run(opType: SyncOpType.refresh);
      if (mounted) {
        showFToast(context: context, title: const Text('已开始刷新同步'));
      }
    } catch (e) {
      if (mounted) {
        showFToast(
          context: context,
          title: const Text('刷新失败'),
          description: Text('$e'),
        );
      }
    }
  }

  /// 删除队列中遗留的 interrupted 行（push 行除外——push 走「继续推送」复用原行）。
  Future<void> _clearInterruptedRows() async {
    final ds = ref.read(syncOpLocalDatasourceProvider);
    final all = await ds.listAll();
    for (final row in all) {
      if (row.status == SyncOpStatus.interrupted &&
          row.type != SyncOpType.push) {
        await ds.deleteTask(row.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
