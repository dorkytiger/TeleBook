import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/f_adaptive_dialog.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/core/service/sync_service.dart';

/// 连接后同步下载页：不可关闭，展示每本书的下载进度与状态。
///
/// 全部下载完成自动回到书籍页；失败可重试。
class SyncDownloadView extends ConsumerStatefulWidget {
  const SyncDownloadView({super.key});

  @override
  ConsumerState<SyncDownloadView> createState() => _SyncDownloadViewState();
}

class _DlBook {
  final String uuid;
  String name;
  int done = 0;
  int total = 0;
  String status = 'downloading'; // downloading / done / failed

  _DlBook(this.uuid, this.name);
}

class _SyncDownloadViewState extends ConsumerState<SyncDownloadView> {
  final Map<String, _DlBook> _books = {};
  bool _running = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    setState(() {
      _running = true;
      _error = null;
      _books.clear();
    });
    try {
      final sync = ref.read(syncServiceProvider.notifier);
      await sync.pullOnly(
        onBookDownload: (uuid, name, done, total) {
          if (!mounted) return;
          setState(() {
            final book = _books.putIfAbsent(
              uuid,
              () => _DlBook(uuid, name),
            );
            book.name = name;
            book.done = done;
            book.total = total;
            book.status = done >= total && total > 0 ? 'done' : 'downloading';
          });
        },
      );
      if (!mounted) return;
      // 完成：全部书标记 done
      setState(() {
        for (final b in _books.values) {
          if (b.status != 'failed') b.status = 'done';
        }
        _running = false;
      });
      // 短暂停留后回到书籍页
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      context.go(AppRoute.main);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _running = false;
        _error = '$e';
      });
      showFDialog<void>(
        context: context,
        builder: (context, style, animate) => FAdaptiveDialog(
          title: const Text('同步下载失败'),
          body: Text('$e'),
          actions: [
            FButton(
              variant: .outline,
              size: .sm,
              onPress: () => Navigator.pop(context),
              child: const Text('关闭'),
            ),
            FButton(
              size: .sm,
              onPress: () {
                Navigator.pop(context);
                _run();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = _books.values.where((b) => b.status == 'done').length;

    return PopScope(
      canPop: false, // 不可关闭
      child: FScaffold(
        header: FHeader.nested(
          title: const Text('正在同步下载书籍'),
          // 无返回键：不可关闭
        ),
        child: _books.isEmpty && _running
            ? const Center(child: FCircularProgress())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Text(
                        '$_error',
                        style: context.theme.typography.body.sm.copyWith(
                          color: context.theme.colors.destructive,
                        ),
                      ),
                    ),
                  Expanded(
                    child: FItemGroup(
                      children: [
                        for (final book in _books.values)
                          .item(
                            prefix: Icon(
                              switch (book.status) {
                                'done' => FLucideIcons.checkCircle,
                                'failed' => FLucideIcons.alertTriangle,
                                _ => FLucideIcons.download,
                              },
                              size: 20,
                            ),
                            title: Text(book.name),
                            subtitle: Text(
                              book.total == 0
                                  ? _statusLabel(book.status)
                                  : '图片 ${book.done}/${book.total} · ${_statusLabel(book.status)}',
                            ),
                            suffix: SizedBox(
                              width: 80,
                              child: FDeterminateProgress(
                                value: book.total == 0
                                    ? (book.status == 'done' ? 1.0 : 0.0)
                                    : book.done / book.total,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        if (_running) const FCircularProgress(),
                        const SizedBox(width: 8),
                        Text(
                          _running
                              ? '正在同步：已下载 $doneCount/${_books.length} 本…'
                              : '同步完成：共 ${_books.length} 本',
                          style: context.theme.typography.body.sm,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  String _statusLabel(String status) => switch (status) {
        'done' => '已完成',
        'failed' => '失败',
        _ => '下载中',
      };
}
