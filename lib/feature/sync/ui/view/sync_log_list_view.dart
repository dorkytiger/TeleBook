import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/sync/datasource/sync_op_local_datasource.dart';
import 'package:tele_book/feature/sync/service/sync_op_service.dart';

/// 本地同步记录（§2.5）：所有同步操作都是队列里的组任务，
/// 这里按队列顺序显示各任务状态（进行中/等待中/完成/失败/中断），
/// 最新在上、带时间便于区分；失败/中断任务可直接「重试」（复用原任务行重跑）。
class SyncLogListView extends ConsumerWidget {
  const SyncLogListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(syncOpQueueProvider).value ?? const <SyncOpTableData>[];
    // 最新在上（running 是当前最新 → 自然在顶部）
    final ops = queue.reversed.toList();

    return FScaffold(
      header: FHeader.nested(
        title: const Text('本地同步记录'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: ops.isEmpty
          ? const Center(child: Text('暂无同步任务'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                FItemGroup(
                  children: [
                    for (final op in ops)
                      .item(
                        prefix: Icon(_statusIcon(op.status), size: 20),
                        title: Text(
                          '${_fmtTime(op.createdAt)} · ${op.title}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          _subtitle(op),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        suffix: op.status == 'running'
                            ? const FCircularProgress(size: .sm)
                            : op.status == SyncOpStatus.failed ||
                                    op.status == SyncOpStatus.interrupted
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FButton.icon(
                                        variant: .ghost,
                                        size: .sm,
                                        onPress: () => _retry(context, ref, op),
                                        child: const Icon(
                                          FLucideIcons.refreshCw,
                                          size: 16,
                                        ),
                                      ),
                                      FButton.icon(
                                        variant: .ghost,
                                        size: .sm,
                                        onPress: () => _dismiss(context, ref, op),
                                        child: const Icon(
                                          FLucideIcons.x,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  )
                                : op.status == SyncOpStatus.waiting
                                    ? FButton.icon(
                                        variant: .ghost,
                                        size: .sm,
                                        onPress: () => _cancel(context, ref, op),
                                        child: const Icon(
                                          FLucideIcons.x,
                                          size: 16,
                                        ),
                                      )
                                    : const SizedBox(width: 16),
                      ),
                  ],
                ),
              ],
            ),
    );
  }

  String _subtitle(SyncOpTableData op) {
    final parts = <String>[
      SyncOpStatus.labelOf(op.status),
      if (op.totalBooks > 0) '${op.doneBooks}/${op.totalBooks} 本',
      if (op.totalPages > 0) '页 ${op.currentPage}/${op.totalPages}',
      if (op.error != null && op.error!.isNotEmpty) op.error!,
    ];
    return parts.join(' · ');
  }

  /// 时间：同年显示 MM-dd HH:mm，跨年带年份；今天显示「今天 HH:mm」。
  static String _fmtTime(DateTime t) {
    final local = t.toLocal();
    final now = DateTime.now();
    final hm =
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    final sameDay = local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
    if (sameDay) return '今天 $hm';
    final md =
        '${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
    if (local.year == now.year) return '$md $hm';
    return '${local.year}-$md $hm';
  }

  Future<void> _retry(
    BuildContext context,
    WidgetRef ref,
    SyncOpTableData op,
  ) async {
    final svc = ref.read(syncOpServiceProvider);
    if (!await svc.canRetry(op.id)) {
      if (context.mounted) {
        showFToast(
          context: context,
          title: const Text('该任务已无法直接重试，请重新发起操作'),
        );
      }
      return;
    }
    await svc.retryTask(op.id);
    if (context.mounted) {
      showFToast(context: context, title: const Text('已重新加入队列'));
    }
  }

  Future<void> _cancel(
    BuildContext context,
    WidgetRef ref,
    SyncOpTableData op,
  ) async {
    final ok = await ref.read(syncOpServiceProvider).cancelTask(op.id);
    if (!context.mounted) return;
    showFToast(
      context: context,
      title: Text(ok ? '已取消「${op.title}」' : '该任务已开始执行，无法取消'),
    );
  }

  /// 移除一条失败/中断记录（不再提示，本地记录中也删除该行）。
  Future<void> _dismiss(
    BuildContext context,
    WidgetRef ref,
    SyncOpTableData op,
  ) async {
    await ref.read(syncOpLocalDatasourceProvider).deleteTask(op.id);
    if (!context.mounted) return;
    showFToast(context: context, title: const Text('已移除该记录'));
  }

  IconData _statusIcon(String status) => switch (status) {
        'running' => FLucideIcons.refreshCw,
        'done' => FLucideIcons.checkCircle,
        'failed' => FLucideIcons.alertTriangle,
        'interrupted' => FLucideIcons.pauseCircle,
        _ => FLucideIcons.clock, // waiting
      };
}
