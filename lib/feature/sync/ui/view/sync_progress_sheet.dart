import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/feature/sync/ui/provider/sync_books_provider.dart';
import 'package:tele_book/feature/sync/ui/widget/book_sync_tile.dart';

/// 底栏点击后弹出的当前同步进度 bottom sheet。
Future<void> showSyncProgressSheet(BuildContext context, WidgetRef ref) {
  final state = ref.read(syncBooksProvider);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.running
                  ? '正在同步 ${state.doneCount}/${state.books.length}...'
                  : '同步结果：成功 ${state.doneCount} · 失败 ${state.failedCount}',
              style: Theme.of(sheetContext).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (state.books.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text('暂无同步任务')),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: state.books.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      BookSyncTile(progress: state.books[index]),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
