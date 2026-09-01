import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:tele_book/feature/sync/ui/provider/sync_books_provider.dart';

/// 单本书同步进度条目（手动同步页 / 底栏进度弹层共用）。
class BookSyncTile extends ConsumerWidget {
  final BookSyncProgress progress;

  const BookSyncTile({super.key, required this.progress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (label, value) = switch (progress.status) {
      SyncBookStatus.pending => ('等待中', 0.0),
      SyncBookStatus.syncing => ('同步中', progress.progress),
      SyncBookStatus.done => ('已完成', 1.0),
      SyncBookStatus.failed => ('失败', progress.progress),
    };
    final color = switch (progress.status) {
      SyncBookStatus.failed => context.theme.colors.destructive,
      SyncBookStatus.done => context.theme.colors.primary,
      _ => context.theme.colors.primary,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                progress.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              progress.status == SyncBookStatus.syncing
                  ? '${(value * 100).toStringAsFixed(0)}%'
                  : label,
              style: context.theme.typography.body.sm.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            color: color,
            backgroundColor: context.theme.colors.mutedForeground.withValues(
              alpha: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}
