import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/book/ui/view/book_list_view.dart';
import 'package:tele_book/feature/collection/ui/view/collection_view.dart';
import 'package:tele_book/feature/download/ui/view/download_list_view.dart';
import 'package:tele_book/feature/main/provider/main_provider.dart';
import 'package:tele_book/feature/setting/ui/provider/setting_provider.dart';
import 'package:tele_book/feature/setting/ui/view/setting_view.dart';
import 'package:tele_book/feature/sync/service/local_conflict_service.dart';
import 'package:tele_book/feature/sync/service/sync_op_service.dart';
import 'package:tele_book/feature/sync/ui/view/local_conflict_list_sheet.dart';
import 'package:tele_book/feature/sync/ui/widget/sync_recovery_gate.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainProvider);
    final notifier = ref.read(mainProvider.notifier);
    return FScaffold(
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SyncStatusStrip(),
          FBottomNavigationBar(
            index: state.currentIndex,
            onChange: (index) => notifier.updateCurrentIndex(index),
            children: [
              FBottomNavigationBarItem(
                icon: Icon(FLucideIcons.book),
                label: Text("书籍"),
              ),
              FBottomNavigationBarItem(
                icon: Icon(FLucideIcons.download),
                label: Text("下载"),
              ),
              FBottomNavigationBarItem(
                icon: Icon(FLucideIcons.star),
                label: Text("收藏夹"),
              ),
              FBottomNavigationBarItem(
                icon: Icon(FLucideIcons.settings),
                label: Text("设置"),
              ),
            ],
          ),
        ],
      ),
      child: Stack(
        children: [
          IndexedStack(
            index: state.currentIndex,
            children: [
              BookListView(),
              DownloadListView(),
              CollectionView(),
              SettingView(),
            ],
          ),
          // §8.0 启动恢复提示（检测到上次中断残留时弹一次）
          const SyncRecoveryGate(),
        ],
      ),
    );
  }
}

/// 底栏上方的全局通知状态条（§0，单一来源 = SyncOp 组任务队列）。
///
/// 展示优先级：
/// 1. 当前运行/等待的**组任务** —— 文案「上传中/同步中 第X/共N本 · 页a/b」，
///    右侧「查看」进入同步任务中心。
/// 2. 待解决**本地冲突**（§7）—— 「查看」进入冲突列表 bottomsheet。
/// 3. 有失败/中断任务 —— 「查看」进入同步任务中心查看错误并重试。
///
/// 阅读进度等静默推送不在通知区出现（§5 决策）；同步服务器未配置时不显示。
/// 文字可换行（最多 2 行），右侧统一「查看」按钮作为入口（不点整条文字）。
class _SyncStatusStrip extends ConsumerWidget {
  const _SyncStatusStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configured = ref.watch(syncConfiguredProvider).value ?? false;
    if (!configured) return const SizedBox.shrink();

    // ① 当前组任务（running 优先，其次 waiting）
    final queue = ref.watch(syncOpQueueProvider).value ?? const <SyncOpTableData>[];
    final current = _currentOp(queue);
    if (current != null) {
      return _strip(context,
        leading: const FCircularProgress(size: .sm),
        text: _opNoticeText(current),
        onTap: () => context.push(AppRoute.syncTasks),
      );
    }

    // ② 本地冲突（§7）
    final localConflicts = ref.watch(localConflictServiceProvider);
    return ValueListenableBuilder<List<LocalConflict>>(
      valueListenable: localConflicts.pending,
      builder: (context, conflicts, _) {
        if (conflicts.isNotEmpty) {
          return _strip(context, 
            leading: Icon(
              FLucideIcons.alertTriangle,
              size: 16,
              color: context.theme.colors.destructive,
            ),
            text: '存在冲突 ${conflicts.length} 项待处理',
            color: context.theme.colors.destructive,
            onTap: () => showLocalConflictSheet(context),
          );
        }
        // ③ 失败/中断任务 → 任务中心（可查看错误与重试）
        final failed = queue
            .where((t) =>
                t.status == SyncOpStatus.failed ||
                t.status == SyncOpStatus.interrupted)
            .length;
        if (failed > 0) {
          return _strip(context, 
            leading: Icon(
              FLucideIcons.alertTriangle,
              size: 16,
              color: context.theme.colors.destructive,
            ),
            text: '有 $failed 个同步任务失败/中断',
            color: context.theme.colors.destructive,
            onTap: () => context.push(AppRoute.syncTasks),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// 全局通知条：左侧图标 + 中间文字（可换行，最多 2 行）+ 右侧统一「查看」按钮。
  Widget _strip(
    BuildContext context, {
    required Widget leading,
    required String text,
    Color? color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      color: context.theme.colors.background,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leading,
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.theme.typography.body.sm.copyWith(
                color: color ?? context.theme.colors.foreground,
              ),
            ),
          ),
          const SizedBox(width: 8),
          FButton(
            variant: .outline,
            size: .sm,
            onPress: onTap,
            child: const Text('查看'),
          ),
        ],
      ),
    );
  }

  /// 组装全局通知文案（§0）：`上传中/同步中 第X/共N本 · 当前 页a/页b`。
  /// X = doneBooks（已完成/已处理到的本序号，1-based，不额外 +1）。
  String _opNoticeText(SyncOpTableData op) {
    final verb = switch (op.type) {
      SyncOpType.push => '上传中',
      SyncOpType.uploadSnapshot => '上传快照中',
      SyncOpType.conflict => '处理冲突中',
      SyncOpType.resume => '恢复中',
      _ => '同步中',
    };
    final bookPart = op.totalBooks > 0
        ? ' 第${op.doneBooks.clamp(1, op.totalBooks)}/共${op.totalBooks}本'
        : '';
    final pagePart = op.totalPages > 0
        ? ' · 当前 ${op.currentPage}/${op.totalPages}页'
        : '';
    return '$verb$bookPart$pagePart';
  }

  /// 当前执行的任务：running 优先，否则队列头 waiting。
  SyncOpTableData? _currentOp(List<SyncOpTableData> queue) {
    for (final t in queue) {
      if (t.status == 'running') return t;
    }
    for (final t in queue) {
      if (t.status == 'waiting') return t;
    }
    return null;
  }
}
