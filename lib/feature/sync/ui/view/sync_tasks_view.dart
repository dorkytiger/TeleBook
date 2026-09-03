import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/common/widget/f_sheet_content.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/sync/datasource/sync_op_local_datasource.dart';
import 'package:tele_book/feature/sync/service/optimistic_download_service.dart';
import 'package:tele_book/feature/sync/service/sync_op_service.dart';

/// 同步任务中心（§0 页面版，替代 bottomsheet）：
/// - [SyncTasksView]：列出**整个队列**的组任务（running/waiting/failed/interrupted，
///   不含历史 done）；点某任务进入详情页。
/// - [SyncTaskDetailView]：任务状态 + 组内书列表；每本书行 subtitle 带整体进度条，
///   点击该书弹出 bottomsheet 看每张图片的进度/状态（失败图片可重试）。
class SyncTasksView extends ConsumerWidget {
  const SyncTasksView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(syncOpQueueProvider).value ?? const <SyncOpTableData>[];
    final queue = all
        .where((t) => t.status != SyncOpStatus.done)
        .toList()
        .reversed
        .toList(); // 最新在上（running 最新 → 顶部）

    return FScaffold(
      header: FHeader.nested(
        title: const Text('同步任务'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: queue.isEmpty
          ? const Center(child: Text('暂无进行中/排队的同步任务'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [for (final op in queue) _taskRow(context, op)],
            ),
    );
  }

  Widget _taskRow(BuildContext context, SyncOpTableData op) {
    final failed = op.status == SyncOpStatus.failed ||
        op.status == SyncOpStatus.interrupted;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: context.theme.colors.background,
        child: InkWell(
          onTap: () => context.push(AppRoute.syncTaskDetail, extra: op),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: context.theme.colors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _statusIcon(op.status),
                  size: 20,
                  color: failed ? context.theme.colors.destructive : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_fmtTime(op.createdAt)} · ${op.title}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.theme.typography.body.md,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _taskSummary(op),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.theme.typography.body.sm.copyWith(
                          color: context.theme.colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (op.status == SyncOpStatus.running)
                  const FCircularProgress(size: .sm)
                else
                  const Icon(FLucideIcons.chevronRight, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _taskSummary(SyncOpTableData op) {
    final parts = <String>[
      SyncOpStatus.labelOf(op.status),
      _directionWord(op),
      if (op.totalBooks > 0) '${op.doneBooks}/${op.totalBooks} 本',
      if (op.totalPages > 0) '页 ${op.currentPage}/${op.totalPages}',
      if (op.error != null && op.error!.isNotEmpty) op.error!,
    ];
    return parts.where((p) => p.isNotEmpty).join(' · ');
  }

  static String _directionWord(SyncOpTableData op) => switch (op.type) {
        SyncOpType.push || SyncOpType.uploadSnapshot => '上传',
        SyncOpType.resume => '恢复',
        _ => '',
      };

  static IconData _statusIcon(String status) => switch (status) {
        'running' => FLucideIcons.refreshCw,
        'failed' => FLucideIcons.alertTriangle,
        'interrupted' => FLucideIcons.pauseCircle,
        _ => FLucideIcons.clock, // waiting
      };

  static String _fmtTime(DateTime t) {
    final local = t.toLocal();
    final hm =
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    final md =
        '${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
    return '$md $hm';
  }
}

/// 单个组任务详情：任务状态/操作 + 组内书列表。
class SyncTaskDetailView extends ConsumerStatefulWidget {
  final SyncOpTableData op;
  const SyncTaskDetailView({super.key, required this.op});

  @override
  ConsumerState<SyncTaskDetailView> createState() => _SyncTaskDetailViewState();
}

class _SyncTaskDetailViewState extends ConsumerState<SyncTaskDetailView> {
  @override
  Widget build(BuildContext context) {
    // 实时行（状态/进度可能已变）
    final all = ref.watch(syncOpQueueProvider).value ?? const <SyncOpTableData>[];
    final live = all.where((t) => t.id == widget.op.id).firstOrNull ?? widget.op;

    return FScaffold(
      header: FHeader.nested(
        title: Text(live.title, maxLines: 1),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _taskCard(context, live),
          const SizedBox(height: 16),
          _booksSection(context, live),
        ],
      ),
    );
  }

  // ── 任务状态卡 + 操作 ────────────────────────────────

  Widget _taskCard(BuildContext context, SyncOpTableData op) {
    final ops = ref.read(syncOpServiceProvider);
    final running = op.status == SyncOpStatus.running;
    final failed = op.status == SyncOpStatus.failed ||
        op.status == SyncOpStatus.interrupted;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        border: Border.all(color: context.theme.colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                SyncTasksView._statusIcon(op.status),
                size: 18,
                color: failed ? context.theme.colors.destructive : null,
              ),
              const SizedBox(width: 6),
              Text(
                '${SyncOpStatus.labelOf(op.status)} · '
                '${SyncTasksView._fmtTime(op.createdAt)}',
                style: context.theme.typography.body.sm.copyWith(
                  color: failed ? context.theme.colors.destructive : null,
                ),
              ),
              const Spacer(),
              if (running) const FCircularProgress(size: .sm),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _progressLine(op),
            style: context.theme.typography.body.md,
          ),
          if (op.error != null && op.error!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              op.error!,
              style: context.theme.typography.body.sm.copyWith(
                color: context.theme.colors.destructive,
              ),
            ),
          ],
          if (failed || op.status == SyncOpStatus.waiting) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (op.status == SyncOpStatus.waiting)
                  FButton(
                    variant: .outline,
                    size: .sm,
                    onPress: () async {
                      final ok = await ops.cancelTask(op.id);
                      if (!context.mounted) return;
                      showFToast(
                        context: context,
                        title: Text(ok ? '已取消' : '该任务已开始执行，无法取消'),
                      );
                    },
                    child: const Text('取消'),
                  ),
                if (failed) ...[
                  FutureBuilder<bool>(
                    future: ops.canRetry(op.id),
                    builder: (context, snap) {
                      if (snap.data == true) {

                        return FButton(
                          size: .sm,
                          onPress: () async {
                            await ops.retryTask(op.id);
                            if (!context.mounted) return;
                            showFToast(
                              context: context,
                              title: const Text('已重新加入队列'),

                            );
                          },
                          child: const Text('重试'),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  FButton.icon(
                    variant: .ghost,
                    size: .sm,
                    onPress: () async {
                      await ref
                          .read(syncOpLocalDatasourceProvider)
                          .deleteTask(op.id);
                      if (context.mounted) context.pop();
                    },
                    child: const Icon(FLucideIcons.x, size: 16),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _progressLine(SyncOpTableData op) {
    final parts = <String>[
      if (op.totalBooks > 0) '第${op.doneBooks.clamp(1, op.totalBooks)}/共${op.totalBooks}本',
      if (op.totalPages > 0) '当前 页 ${op.currentPage}/${op.totalPages}',
      SyncTasksView._directionWord(op),
    ];
    return parts.where((p) => p.isNotEmpty).join(' · ');
  }

  // ── 组内书列表 ────────────────────────────────────────

  Widget _booksSection(BuildContext context, SyncOpTableData op) {
    final ops = ref.read(syncOpServiceProvider);
    final running = op.status == SyncOpStatus.running;
    if (!running) {
      // 非运行：从规格（payload）静态列出书（等待中/失败）
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('书籍', style: context.theme.typography.body.md),
          const SizedBox(height: 8),
          ..._staticBooks(context, op),
        ],
      );
    }
    return ValueListenableBuilder<int>(
      valueListenable: ops.opDetailRevision,
      builder: (context, _, __) {
        final books = ops.detailOf(op.id);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('书籍（${books.length}）', style: context.theme.typography.body.md),
            const SizedBox(height: 8),
            if (books.isEmpty)
              Text('组内书籍加载中…',
                  style: context.theme.typography.body.sm.copyWith(
                    color: context.theme.colors.mutedForeground,
                  ))
            else
              for (final book in books) _bookTile(context, ops, op, book),
          ],
        );
      },
    );
  }

  Widget _bookTile(
    BuildContext context,
    SyncOpService ops,
    SyncOpTableData op,
    SyncOpBookDetail book,
  ) {
    final failed = book.failedFiles > 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: context.theme.colors.background,
        child: InkWell(
          onTap: () => _showBookProgressSheet(context, ops, op, book),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: context.theme.colors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                LocalImageWidget(
                  imagePath: GlobalConfig.resolveBookPath('${book.uuid}/cover.jpg'),
                  width: 32,
                  height: 46,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.theme.typography.body.md,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _bookStatusText(book),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.theme.typography.body.xs.copyWith(
                          color: failed ? context.theme.colors.destructive : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FDeterminateProgress(value: _bookProgress(book)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(FLucideIcons.chevronRight, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _bookProgress(SyncOpBookDetail book) {
    if (book.status == 'done') return 1;
    if (book.status == 'pending') return 0;
    if (book.files.isEmpty) return book.status == 'syncing' ? 0 : 1;
    return (book.doneFiles / book.files.length).clamp(0.0, 1.0);
  }

  /// 书的阶段 + 方向文案（上传/下载 + 等待中/进行中/完成/失败）。
  static String _bookStatusText(SyncOpBookDetail book) {
    final dir = book.direction == 'download'
        ? '下载'
        : book.direction == 'upload'
            ? '上传'
            : '同步';
    return switch (book.status) {
      'pending' => '等待$dir…',
      'syncing' => '$dir中… ${book.doneFiles}/${book.files.length} 页',
      'done' => '已完成$dir（${book.files.length} 页）',
      'failed' => '$dir失败：${book.failedFiles} 页失败，可重试',
      _ => '$dir中…',
    };
  }

  /// 点击书 → bottomsheet 展示该书的每张图片进度（上传/下载）。
  Future<void> _showBookProgressSheet(
    BuildContext context,
    SyncOpService ops,
    SyncOpTableData op,
    SyncOpBookDetail book,
  ) async {
    await showFSheet(
      context: context,
      side: .btt,
      mainAxisMaxRatio: 0.8,
      builder: (context) => FSheetContent(
        side: .btt,
        child: Consumer(
          builder: (context, ref, _) {
            final downloader = ref.read(optimisticDownloadServiceProvider);
            final live = ref.watch(syncOpQueueProvider).value
                    ?.where((t) => t.id == op.id)
                    .firstOrNull ??
                op;
            // 实时刷新：任务明细任何书/文件状态/进度变化都会重建弹层
            return ValueListenableBuilder<int>(
              valueListenable: ops.opDetailRevision,
              builder: (context, _, __) {
                // 运行中/失败/中断都优先读明细（失败任务的明细被保留，§0），
                // 末了再回退到打开时的快照，避免"一直转圈"
                final liveBook = ops
                    .detailOf(op.id)
                    .where((b) => b.uuid == book.uuid)
                    .firstOrNull;
                final cur = liveBook ?? book;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FSheetContent.drag(),
                    FSheetContent.title(context, cur.name),
                    FSheetContent.subTitle(context, _bookStatusText(cur)),
                    const SizedBox(height: 8),
                    if (cur.status == 'pending' || cur.files.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: Text('还没有开始同步该书文件')),
                      )
                    else
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            for (final file in cur.files)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    LocalImageWidget(
                                      imagePath: GlobalConfig.resolveBookPath(
                                        '${cur.uuid}/${file.relPath}',
                                      ),
                                      width: 28,
                                      height: 40,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            file.relPath.split('/').last,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: context
                                                .theme.typography.body.sm,
                                          ),
                                          const SizedBox(height: 2),
                                          if (file.status == 'failed' &&
                                              file.error != null)
                                            Text(
                                              file.error!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: context
                                                  .theme.typography.body.xs
                                                  .copyWith(
                                                color: context.theme.colors
                                                    .destructive,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _fileSuffix(context, ops, downloader, live,
                                        cur, file),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _fileSuffix(
    BuildContext context,
    SyncOpService ops,
    OptimisticDownloadService downloader,
    SyncOpTableData op,
    SyncOpBookDetail book,
    SyncOpFileDetail file,
  ) {
    switch (file.status) {
      case 'syncing':
        return const FCircularProgress(size: .sm);
      case 'pending':
        return Icon(
          FLucideIcons.clock,
          size: 16,
          color: context.theme.colors.mutedForeground,
        );
      case 'done':
        return Icon(
          FLucideIcons.checkCircle,
          size: 16,
          color: context.theme.colors.primary,
        );
      case 'failed':
        return FutureBuilder<bool>(
          future: downloader.hasSyncDown(book.uuid),
          builder: (context, snap) {
            // 下载类书：重试这一张
            if (snap.data == true) {
              return FButton.icon(
                variant: .ghost,
                size: .sm,
                onPress: () async {
                  final ok = await downloader.retryFile(
                    book.uuid,
                    file.relPath,
                    detail: ops.openDetailWriter(op.id),
                  );
                  if (!context.mounted) return;
                  showFToast(
                    context: context,
                    title: Text(
                      ok
                          ? '已重新下载：${file.relPath.split('/').last}'
                          : '重试失败，请稍后再试',
                    ),
                  );
                },
                child: const Icon(FLucideIcons.refreshCw, size: 14),
              );
            }
            // 上传类书：单文件无法单独重传 → 重试整个任务（幂等，已传的自动跳过）
            return FutureBuilder<bool>(
              future: ops.canRetry(op.id),
              builder: (context, s2) {
                if (s2.data == true) {
                  return FButton.icon(
                    variant: .ghost,
                    size: .sm,
                    onPress: () async {
                      await ops.retryTask(op.id);
                      if (!context.mounted) return;
                      showFToast(
                        context: context,
                        title: const Text('已重新加入队列'),
                      );
                    },
                    child: const Icon(FLucideIcons.refreshCw, size: 14),
                  );
                }
                return Text('失败',
                    style: context.theme.typography.body.sm.copyWith(
                      color: context.theme.colors.destructive,
                    ));
              },
            );
          },
        );
      default:
        return Icon(
          FLucideIcons.clock,
          size: 16,
          color: context.theme.colors.mutedForeground,
        );
    }
  }

  /// 非运行任务的静态书列表（来自 push 任务 payload）。
  List<Widget> _staticBooks(BuildContext context, SyncOpTableData op) {
    if (op.type != SyncOpType.push || op.payload == null) {
      return [
        Text('该任务没有可展开的书籍明细',
            style: context.theme.typography.body.sm.copyWith(
              color: context.theme.colors.mutedForeground,
            )),
      ];
    }
    final spec = jsonDecode(op.payload!) as Map<String, dynamic>;
    final items = (spec['items'] as List? ?? const []);
    final isFailed = op.status == SyncOpStatus.failed ||
        op.status == SyncOpStatus.interrupted;
    return [
      for (final it in items.cast<Map<String, dynamic>>())
        if ((it['op'] as String? ?? 'upsert') == 'upsert')
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                const Icon(FLucideIcons.book, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    it['name'] as String? ?? '（未知书名）',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '上传 · ${isFailed ? '同步失败' : '等待中'}',
                  style: context.theme.typography.body.sm.copyWith(
                    color: isFailed ? context.theme.colors.destructive : null,
                  ),
                ),
              ],
            ),
          ),
    ];
  }
}
