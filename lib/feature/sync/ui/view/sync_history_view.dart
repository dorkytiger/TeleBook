import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/sync/ui/provider/sync_history_provider.dart';

/// 同步历史记录页：时间 / 操作描述 / tag，点选归档可恢复（覆盖）。
class SyncHistoryView extends ConsumerStatefulWidget {
  const SyncHistoryView({super.key});

  @override
  ConsumerState<SyncHistoryView> createState() => _SyncHistoryViewState();
}

class _SyncHistoryViewState extends ConsumerState<SyncHistoryView> {
  @override
  Widget build(BuildContext context) {
    final history = ref.watch(syncHistoryProvider);

    return FScaffold(
      header: FHeader.nested(
        title: const Text('同步历史'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: history.when(
        loading: () => const Center(child: FCircularProgress()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('加载历史失败: $e', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FButton(
                variant: .outline,
                size: .sm,
                onPress: () => ref.invalidate(syncHistoryProvider),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('暂无同步记录'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(syncHistoryProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, index) =>
                  _buildItem(context, items[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, SyncHistoryItem item) {
    final theme = context.theme;
    final icon = switch (item.opType) {
      'import' => FLucideIcons.upload,
      'modify' => FLucideIcons.pencil,
      'delete' => FLucideIcons.trash,
      'manual_sync' => FLucideIcons.refreshCw,
      'restore' => FLucideIcons.rotateCcw,
      _ => FLucideIcons.clock,
    };

    return FTile(
      onPress: () => context.push(AppRoute.syncHistoryDetail, extra: item),
      prefix: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: theme.colors.mutedForeground.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: theme.colors.mutedForeground),
      ),
      title: Text('${item.opLabel}（${item.bookCount} 本）'),
      subtitle: Text(_formatTime(item.createdAt)),
      suffix: Text(
        item.tagLabel,
        style: theme.typography.body.sm.copyWith(
          color: item.tag == 'manual'
              ? theme.colors.primary
              : theme.colors.mutedForeground,
        ),
      ),
    );
  }

  String _formatTime(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${t.year}-${two(t.month)}-${two(t.day)} ${two(t.hour)}:${two(t.minute)}';
  }
}
