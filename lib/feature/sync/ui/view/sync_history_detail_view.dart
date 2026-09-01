import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/f_adaptive_dialog.dart';
import 'package:tele_book/common/widget/f_sheet_content.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/feature/sync/ui/provider/sync_history_provider.dart';

/// 归档详情页：查看归档的书籍列表，确认后整库恢复（带每本下载进度）。
///
/// 恢复成功 → 返回书籍页；失败 → 弹窗报错。
class SyncHistoryDetailView extends ConsumerStatefulWidget {
  final SyncHistoryItem item;

  const SyncHistoryDetailView({super.key, required this.item});

  @override
  ConsumerState<SyncHistoryDetailView> createState() =>
      _SyncHistoryDetailViewState();
}

class _BookRestoreProgress {
  final String uuid;
  final String name;
  int totalFiles;
  int doneFiles = 0;

  _BookRestoreProgress({required this.uuid, required this.name, required this.totalFiles});

  double get ratio => totalFiles == 0 ? 1 : (doneFiles / totalFiles).clamp(0.0, 1.0);
}

class _SyncHistoryDetailViewState extends ConsumerState<SyncHistoryDetailView> {
  late final List<_BookRestoreProgress> _books = [
    for (final b in widget.item.books)
      _BookRestoreProgress(uuid: b.uuid, name: b.name, totalFiles: b.files.length),
  ];
  bool _restoring = false;
  String? _error;

  Future<void> _restore() async {
    if (_restoring) return;
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (context, style, animate) => FAdaptiveDialog(
        title: const Text('确认整库恢复'),
        body: Text(
          '将把整个书库覆盖为 ${widget.item.opLabel}（${widget.item.tagLabel}）时'
          '的快照（${_books.length} 本书），当前未同步的本地修改会丢失，不可撤销。是否继续？',
        ),
        actions: [
          FButton(
            variant: .destructive,
            size: .sm,
            onPress: () => Navigator.pop(context, true),
            child: const Text('覆盖恢复'),
          ),
          FButton(
            variant: .outline,
            size: .sm,
            onPress: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _restoring = true;
      _error = null;
      for (final b in _books) {
        b.doneFiles = 0;
      }
    });

    try {
      final sync = ref.read(syncServiceProvider.notifier);
      await sync.restoreBook(historyId: widget.item.id);
      // 拉取恢复事件并下载图片（每本进度回调）
      await sync.pullOnly(
        onBookDownload: (uuid, name, done, total) {
          if (!mounted) return;
          final book = _books.where((b) => b.uuid == uuid).firstOrNull;
          if (book != null) {
            setState(() {
              book.doneFiles = done;
              book.totalFiles = total;
            });
          }
        },
      );
      if (!mounted) return;
      showFToast(context: context, title: const Text('恢复成功'));
      context.go(AppRoute.main); // 返回书籍页面
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _restoring = false;
        _error = '$e';
      });
      showFDialog<void>(
        context: context,
        builder: (context, style, animate) => FAdaptiveDialog(
          title: const Text('恢复失败'),
          body: Text('$e'),
          actions: [
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
  }

  /// 弹出单本的下载进度明细（逐文件状态）。
  void _showBookProgress(_BookRestoreProgress book) {
    showFSheet(
      context: context,
      side: .btt,
      mainAxisMaxRatio: null,
      builder: (context) => FSheetContent(
        side: .btt,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FSheetContent.drag(),
            FSheetContent.title(context, book.name),
            FSheetContent.subTitle(
              context,
              '图片 ${book.doneFiles}/${book.totalFiles}',
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: book.ratio,
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = _books.where((b) => b.doneFiles >= b.totalFiles).length;

    return FScaffold(
      header: FHeader.nested(
        title: const Text('归档详情'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              '${widget.item.opLabel}（${widget.item.tagLabel}）· '
              '共 ${_books.length} 本',
              style: context.theme.typography.body.sm.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
          ),
          Expanded(
            child: FItemGroup(
              children: [
                for (final book in _books)
                  .item(
                    prefix: Icon(
                      book.doneFiles >= book.totalFiles
                          ? FLucideIcons.checkCircle
                          : FLucideIcons.book,
                      size: 20,
                    ),
                    title: Text(book.name),
                    subtitle: Text(
                      book.totalFiles == 0
                          ? '无图片'
                          : '图片 ${book.doneFiles}/${book.totalFiles}',
                    ),
                    suffix: _restoring
                        ? SizedBox(
                            width: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: book.ratio,
                                minHeight: 6,
                              ),
                            ),
                          )
                        : null,
                    onPress: _restoring
                        ? () => _showBookProgress(book)
                        : null,
                  ),
              ],
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '恢复失败：$_error',
                style: context.theme.typography.body.sm.copyWith(
                  color: context.theme.colors.destructive,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FButton(
              variant: .destructive,
              onPress: _restoring
                  ? null
                  : () => _restore(),
              child: _restoring
                  ? Text('恢复中：$doneCount/${_books.length} 本…')
                  : const Text('确认恢复'),
            ),
          ),
        ],
      ),
    );
  }
}
