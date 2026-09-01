import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:tele_book/common/widget/f_adaptive_dialog.dart';
import 'package:tele_book/feature/book/ui/view/book_list_view.dart';
import 'package:tele_book/feature/collection/ui/view/collection_view.dart';
import 'package:tele_book/feature/download/ui/view/download_list_view.dart';
import 'package:tele_book/feature/main/provider/main_provider.dart';
import 'package:tele_book/feature/setting/ui/view/setting_view.dart';
import 'package:tele_book/feature/sync/service/sync_mutation_service.dart';
import 'package:tele_book/feature/sync/ui/provider/sync_books_provider.dart';
import 'package:tele_book/feature/sync/ui/provider/sync_status_provider.dart';
import 'package:tele_book/feature/sync/ui/view/conflict_resolve_sheet.dart';
import 'package:tele_book/feature/sync/ui/view/sync_progress_sheet.dart';

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
      child: IndexedStack(
        index: state.currentIndex,
        children: [
          BookListView(),
          DownloadListView(),
          CollectionView(),
          SettingView(),
        ],
      ),
    );
  }
}

/// 底栏上方的同步状态条：冲突（需先解决）/ 同步中 / 待同步 N（点击立即同步）。
/// 同时监听同步错误：出错弹窗提示（含重试）。
class _SyncStatusStrip extends ConsumerStatefulWidget {
  const _SyncStatusStrip();

  @override
  ConsumerState<_SyncStatusStrip> createState() => _SyncStatusStripState();
}

class _SyncStatusStripState extends ConsumerState<_SyncStatusStrip> {
  SyncMutationService? _mutation;

  @override
  void initState() {
    super.initState();
    _mutation = ref.read(syncMutationServiceProvider);
    _mutation!.lastError.addListener(_onSyncError);
  }

  @override
  void dispose() {
    _mutation?.lastError.removeListener(_onSyncError);
    super.dispose();
  }

  void _onSyncError() {
    final err = _mutation?.lastError.value;
    if (err == null || !mounted) return;
    // 先清空再弹，避免重复弹窗
    _mutation!.lastError.value = null;
    showFDialog<void>(
      context: context,
      builder: (context, style, animate) => FAdaptiveDialog(
        title: const Text('同步出错'),
        body: Text(err),
        actions: [
          FButton(
            variant: .destructive,
            size: .sm,
            onPress: () {
              Navigator.pop(context);
              _mutation?.drain();
            },
            child: const Text('重试'),
          ),
          FButton(
            variant: .outline,
            size: .sm,
            onPress: () => Navigator.pop(context),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(syncStatusProvider);
    final manualSync = ref.watch(syncBooksProvider);
    if (!status.configured) return const SizedBox.shrink();

    final Widget content;
    VoidCallback? onTap;
    if (status.conflictCount > 0) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FLucideIcons.alertTriangle,
            size: 16,
            color: context.theme.colors.destructive,
          ),
          const SizedBox(width: 8),
          Text(
            '存在冲突，需先解决才能处理（${status.conflictCount}）',
            style: context.theme.typography.body.sm.copyWith(
              color: context.theme.colors.destructive,
            ),
          ),
        ],
      );
      onTap = () => showConflictResolveSheet(context, ref);
    } else if (manualSync.running) {
      // 手动同步进行中：显示当前进度，点击查看明细
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text('同步中 · 当前进度 ${manualSync.doneCount}/${manualSync.books.length} 点击查看'),
        ],
      );
      onTap = () => showSyncProgressSheet(context, ref);
    } else if (status.syncing) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              status.syncDetail ?? '同步中...',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else if (status.pendingCount > 0) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FLucideIcons.refreshCw, size: 16, color: context.theme.colors.primary),
          const SizedBox(width: 8),
          Text('待同步 ${status.pendingCount} 项（点击立即同步）'),
        ],
      );
      onTap = () => _mutation?.drain();
    } else {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6),
        color: context.theme.colors.background,
        child: Center(child: content),
      ),
    );
  }
}
