import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/f_adaptive_dialog.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/feature/sync/model/request/sync_request.dart';

/// 连接后同步下载页：不可关闭，展示每本书的下载进度与状态。
///
/// 全部下载成功自动回到书籍页；有失败项时停留在本页，
/// 每本失败的书可单独重试（失败文件按 hash 补下，已成功的不重复下载）。
class SyncDownloadView extends ConsumerStatefulWidget {
  const SyncDownloadView({super.key});

  @override
  ConsumerState<SyncDownloadView> createState() => _SyncDownloadViewState();
}

class _DlBook {
  final String uuid;
  String name;
  List<BookFileMeta> files = const []; // 拉取事件上报的文件清单（重试用）
  int done = 0;
  int total = 0;
  int failed = 0;
  String status = 'downloading'; // downloading / done / failed
  bool retrying = false;

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
        onBookFiles: (uuid, name, files) {
          if (!mounted) return;
          setState(() {
            final book = _books.putIfAbsent(uuid, () => _DlBook(uuid, name));
            book.name = name;
            book.files = files;
            book.total = files.length;
          });
        },
        onBookDownload: (uuid, name, done, total) {
          if (!mounted) return;
          setState(() {
            final book = _books.putIfAbsent(uuid, () => _DlBook(uuid, name));
            book.name = name;
            book.done = done;
            book.total = total;
            if (book.status == 'downloading' && done >= total && total > 0) {
              book.status = 'done';
            }
          });
        },
        onBookFileError: (uuid, relPath, error) {
          if (!mounted) return;
          setState(() {
            final book = _books.putIfAbsent(uuid, () => _DlBook(uuid, ''));
            book.failed++;
            book.status = 'failed';
          });
        },
      );
      if (!mounted) return;
      // 完成：按失败数收敛状态（失败项停留本页，等待重试）
      setState(() {
        for (final b in _books.values) {
          if (b.failed > 0) {
            b.status = 'failed';
          } else if (b.status != 'failed') {
            b.status = 'done';
          }
        }
        _running = false;
      });
      final hasFailed = _books.values.any((b) => b.status == 'failed');
      if (hasFailed) return; // 有失败：停留本页，展示重试入口
      // 全部成功：短暂停留后回到书籍页
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

  /// 重试单本书：按该书文件清单补下缺失图片。
  Future<void> _retryBook(_DlBook book) async {
    if (book.retrying) return;
    setState(() {
      book.retrying = true;
      book.status = 'downloading';
      book.done = 0;
      book.failed = 0;
    });
    try {
      final sync = ref.read(syncServiceProvider.notifier);
      final ok = await sync.retryBookFiles(
        uuid: book.uuid,
        name: book.name,
        files: book.files,
        onProgress: (done, total) {
          if (!mounted) return;
          setState(() {
            book.done = done;
            book.total = total;
          });
        },
        onFileError: (relPath, error) {
          if (!mounted) return;
          setState(() => book.failed++);
        },
      );
      if (!mounted) return;
      setState(() {
        book.retrying = false;
        book.status = ok ? 'done' : 'failed';
      });
      if (!ok) {
        showFToast(
          context: context,
          title: const Text('仍有图片下载失败，可再次重试'),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        book.retrying = false;
        book.status = 'failed';
      });
      showFToast(
        context: context,
        title: const Text('重试失败'),
        description: Text('$e'),
      );
    }
  }

  /// 重试全部失败的书（逐个串行）。
  Future<void> _retryAllFailed() async {
    final failed = _books.values.where((b) => b.status == 'failed').toList();
    for (final book in failed) {
      if (!mounted) return;
      await _retryBook(book);
    }
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = _books.values.where((b) => b.status == 'done').length;
    final failedCount = _books.values.where((b) => b.status == 'failed').length;

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
                                  : '图片 ${book.done}/${book.total}'
                                      '${book.failed > 0 ? ' · ${book.failed} 张失败' : ''}'
                                      ' · ${_statusLabel(book.status)}',
                            ),
                            suffix: book.status == 'failed' && !book.retrying
                                ? FButton.icon(
                                    variant: .outline,
                                    size: .sm,
                                    onPress: () => _retryBook(book),
                                    child: const Icon(FLucideIcons.refreshCw),
                                  )
                                : SizedBox(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (_running) const FCircularProgress(),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _running
                                    ? '正在同步：已下载 $doneCount/${_books.length} 本…'
                                    : failedCount > 0
                                        ? '同步完成：共 ${_books.length} 本，$failedCount 本下载失败'
                                        : '同步完成：共 ${_books.length} 本',
                                style: context.theme.typography.body.sm,
                              ),
                            ),
                          ],
                        ),
                        if (!_running && failedCount > 0) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: FButton(
                                  variant: .outline,
                                  onPress: _retryAllFailed,
                                  child: const Text('重试全部失败'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FButton(
                                  onPress: () => context.go(AppRoute.main),
                                  child: const Text('返回书籍页'),
                                ),
                              ),
                            ],
                          ),
                        ],
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
