import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/feature/sync/ui/provider/sync_books_provider.dart';
import 'package:tele_book/feature/sync/ui/widget/book_sync_tile.dart';

/// 手动同步页：列出全部书籍，点"开始"逐本同步（每本进度条），完成后返回。
class SyncBooksView extends ConsumerWidget {
  const SyncBooksView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(syncBooksProvider);
    final notifier = ref.read(syncBooksProvider.notifier);

    return FScaffold(
      header: FHeader.nested(
        title: const Text('手动同步'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      footer: Padding(
        padding: const EdgeInsets.all(12),
        child: FButton(
          onPress: state.running ? null : notifier.start,
          child: state.running
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FCircularProgress(),
                    const SizedBox(width: 8),
                    Text('同步中 ${state.doneCount}/${state.books.length}'),
                  ],
                )
              : Text(state.books.isEmpty ? '开始同步' : '重新同步'),
        ),
      ),
      child: state.books.isEmpty && !state.running
          ? const Center(child: Text('暂无书籍'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.books.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final b = state.books[index];
                return BookSyncTile(progress: b);
              },
            ),
    );
  }
}
