import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/common/widget/f_sheet_content.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/sync/service/optimistic_download_service.dart';
import 'package:tele_book/feature/sync/service/sync_op_service.dart';

/// 全局通知点击后弹出的「当前同步组任务明细」bottom sheet（§0）。
///
/// - 头部：任务名 + 状态 + 行级进度（第X/共N本 · 页a/b）+ 错误提示。
/// - 组内书列表：每本一行（封面 prefix / 书名 / 已 x/y 页 + 失败数），
///   点击展开**每页**：缩略图 / 文件名 / 状态或进度条；失败的页提供「重试」
///   （仅下载类书，sync_down 有该页记录才可重试，§0 页级错误处理）。
/// - 任务失败/中断（执行器仍在内存）→「重试」直接重跑同一组任务。
class SyncOpSheetBody extends ConsumerStatefulWidget {
  const SyncOpSheetBody({super.key});

  @override
  ConsumerState<SyncOpSheetBody> createState() => _SyncOpSheetBodyState();
}

class _SyncOpSheetBodyState extends ConsumerState<SyncOpSheetBody> {
  /// 展开的书（uuid）。
  final Set<String> _expanded = {};

  @override
  Widget build(BuildContext context) {
    final queue = ref.watch(syncOpQueueProvider).value ?? const <SyncOpTableData>[];
    final current = _currentOp(queue);
    if (current == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FSheetContent.drag(),
          const SizedBox(height: 24),
          const Center(child: Text('暂无进行中的同步任务')),
        ],
      );
    }

    final ops = ref.read(syncOpServiceProvider);
    return ValueListenableBuilder<int>(
      valueListenable: ops.opDetailRevision,
      builder: (context, _, __) {
        final books = ops.detailOf(current.id);
        final retryable = current.status == SyncOpStatus.failed ||
            current.status == SyncOpStatus.interrupted;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FSheetContent.drag(),
            FSheetContent.title(
              context,
              '${current.title} · ${SyncOpStatus.labelOf(current.status)}',
            ),
            const SizedBox(height: 4),
            if (current.error != null && current.error!.isNotEmpty)
              FAlert(
                title: Text(
                  retryable ? '任务${SyncOpStatus.labelOf(current.status)}' : '提示',
                  style: context.theme.typography.body.sm,
                ),
                subtitle: Text(current.error!, maxLines: 3),
              ),
            const SizedBox(height: 4),
            Text(
              _summaryLine(current),
              style: context.theme.typography.body.sm.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
            const SizedBox(height: 8),
            if (retryable) ...[
              Align(
                alignment: Alignment.centerRight,
                child: FutureBuilder<bool>(
                  future: ops.canRetry(current.id),
                  builder: (context, snap) {
                    if (snap.data != true) {
                      return Text(
                        'App 重启后需重新发起该操作',
                        style: context.theme.typography.body.sm.copyWith(
                          color: context.theme.colors.mutedForeground,
                        ),
                      );
                    }
                    return FButton(
                      variant: .primary,
                      size: .sm,
                      prefix: const Icon(FLucideIcons.refreshCw, size: 16),
                      onPress: () async {
                        await ops.retryTask(current.id);
                        if (context.mounted) {
                          showFToast(
                            context: context,
                            title: const Text('已重新加入队列'),
                          );
                        }
                      },
                      child: const Text('重试全部'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (current.status == SyncOpStatus.waiting) ...[
              // 当前任务还在排队：允许取消（避免误入队/连点）
              Align(
                alignment: Alignment.centerRight,
                child: FButton.icon(
                  variant: .outline,
                  size: .sm,
                  onPress: () async {
                    final ok = await ops.cancelTask(current.id);
                    if (!context.mounted) return;
                    showFToast(
                      context: context,
                      title: Text(ok ? '已取消' : '该任务已开始执行，无法取消'),
                    );
                  },
                  child: const Icon(FLucideIcons.x, size: 16),
                ),
              ),
              const SizedBox(height: 8),
            ],
            _queuedSection(context, ops, queue, current),
            Flexible(
              child: books.isEmpty
                  ? Center(
                      child: Text(
                        current.status == SyncOpStatus.waiting
                            ? '排队中…'
                            : '暂无组内明细',
                        style: context.theme.typography.body.sm.copyWith(
                          color: context.theme.colors.mutedForeground,
                        ),
                      ),
                    )
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        for (final book in books) ...[
                          _bookTile(context, ops, current.id, book),
                          if (_expanded.contains(book.uuid))
                            ..._fileRows(context, ops, current.id, book),
                          const Divider(height: 1),
                        ],
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }

  /// 队列中其它等待任务：展示并可取消（避免误入队/连点后无法撤单）。
  Widget _queuedSection(
    BuildContext context,
    SyncOpService ops,
    List<SyncOpTableData> queue,
    SyncOpTableData current,
  ) {
    final queued = queue
        .where((t) => t.status == SyncOpStatus.waiting && t.id != current.id)
        .toList();
    if (queued.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '排队中（${queued.length}）',
            style: context.theme.typography.body.sm.copyWith(
              color: context.theme.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: 2),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 150),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final q in queued)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${_fmtTime(q.createdAt)} · ${q.title}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.theme.typography.body.sm,
                          ),
                        ),
                        FButton.icon(
                          variant: .ghost,
                          size: .sm,
                          onPress: () async {
                            final ok = await ops.cancelTask(q.id);
                            if (!context.mounted) return;
                            showFToast(
                              context: context,
                              title: Text(
                                ok ? '已取消「${q.title}」' : '该任务已开始执行，无法取消',
                              ),
                            );
                          },
                          child: const Icon(FLucideIcons.x, size: 14),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _fmtTime(DateTime t) {
    final local = t.toLocal();
    final hm =
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    final md =
        '${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
    return '$md $hm';
  }

  String _summaryLine(SyncOpTableData op) {    final bookPart = op.totalBooks > 0
        ? '第${op.doneBooks + 1}/共${op.totalBooks}本'
        : '';
    final pagePart = op.totalPages > 0
        ? (bookPart.isEmpty ? '' : ' · ') + '页 ${op.currentPage}/${op.totalPages}'
        : '';
    return '$bookPart$pagePart'.trim().isEmpty ? '任务进行中' : '$bookPart$pagePart';
  }

  /// 一本书一行：封面 prefix / 书名 / 进度摘要；点击展开每页。
  Widget _bookTile(
    BuildContext context,
    SyncOpService ops,
    int taskId,
    SyncOpBookDetail book,
  ) {
    final expanded = _expanded.contains(book.uuid);
    return FItem(
      title: Text(book.name),
      subtitle: Text(_bookSummary(book)),
      prefix: LocalImageWidget(
        imagePath: GlobalConfig.resolveBookPath('${book.uuid}/cover.jpg'),
        width: 32,
        height: 44,
      ),
      suffix: Icon(
        expanded ? FLucideIcons.chevronUp : FLucideIcons.chevronDown,
        size: 18,
      ),
      onPress: () => setState(() {
        if (expanded) {
          _expanded.remove(book.uuid);
        } else {
          _expanded.add(book.uuid);
        }
      }),
    );
  }

  String _bookSummary(SyncOpBookDetail book) {
    final failed = book.failedFiles;
    if (book.status == 'failed' && failed > 0) {
      return '存在失败项 $failed · 已 ${book.doneFiles}/${book.files.length}';
    }
    return switch (book.status) {
      'done' => '已完成 ${book.files.length} 页',
      'failed' => '同步失败，可重试',
      _ => '进行中 ${book.doneFiles}/${book.files.length} 页',
    };
  }

  /// 展开后的每页行：缩略图 / 文件名 / 状态或进度 / 失败页重试。
  List<Widget> _fileRows(
    BuildContext context,
    SyncOpService ops,
    int taskId,
    SyncOpBookDetail book,
  ) {
    return [
      for (final file in book.files)
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 4, bottom: 2),
          child: Row(
            children: [
              LocalImageWidget(
                imagePath: GlobalConfig.resolveBookPath(
                  '${book.uuid}/${file.relPath}',
                ),
                width: 28,
                height: 40,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _fileName(file.relPath),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.theme.typography.body.sm,
                    ),
                    if (file.status == 'failed' && file.error != null)
                      Text(
                        file.error!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.theme.typography.body.xs.copyWith(
                          color: context.theme.colors.destructive,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _fileSuffix(context, ops, taskId, book, file),
            ],
          ),
        ),
    ];
  }

  Widget _fileSuffix(
    BuildContext context,
    SyncOpService ops,
    int taskId,
    SyncOpBookDetail book,
    SyncOpFileDetail file,
  ) {
    switch (file.status) {
      case 'syncing':
        return SizedBox(
          width: 72,
          child: FDeterminateProgress(value: file.progress.clamp(0.0, 1.0)),
        );
      case 'done':
        return Icon(
          FLucideIcons.checkCircle,
          size: 16,
          color: context.theme.colors.primary,
        );
      case 'failed':
        // 页级重试：仅 sync_down 有该书（下载类任务）才可用
        return FutureBuilder<bool>(
          future: ref.read(optimisticDownloadServiceProvider).hasSyncDown(book.uuid),
          builder: (context, snap) {
            if (snap.data != true) {
              return Text(
                '失败',
                style: context.theme.typography.body.sm.copyWith(
                  color: context.theme.colors.destructive,
                ),
              );
            }
            return FButton.icon(
              variant: .ghost,
              size: .sm,
              onPress: () => _retryFile(context, ops, taskId, book, file),
              child: const Icon(FLucideIcons.refreshCw, size: 14),
            );
          },
        );
      default: // pending
        return Icon(
          FLucideIcons.clock,
          size: 16,
          color: context.theme.colors.mutedForeground,
        );
    }
  }

  Future<void> _retryFile(
    BuildContext context,
    SyncOpService ops,
    int taskId,
    SyncOpBookDetail book,
    SyncOpFileDetail file,
  ) async {
    final ok = await ref.read(optimisticDownloadServiceProvider).retryFile(
          book.uuid,
          file.relPath,
          detail: ops.openDetailWriter(taskId),
        );
    if (!context.mounted) return;
    showFToast(
      context: context,
      title: Text(ok ? '已重新下载：${_fileName(file.relPath)}' : '重试失败，请稍后再试'),
    );
  }

  static String _fileName(String relPath) =>
      relPath.split('/').last;
}

/// 打开明细面板（全局通知点击）。
Future<void> showSyncOpSheet(BuildContext context) {
  return showFSheet(
    context: context,
    side: .btt,
    mainAxisMaxRatio: 0.9,
    builder: (context) => FSheetContent(
      side: .btt,
      child: const SyncOpSheetBody(),
    ),
  );
}

/// 当前执行的任务：running 优先，否则队列头 waiting（failed/interrupted
/// 由「本地同步记录」页展示并提供重试）。
SyncOpTableData? _currentOp(List<SyncOpTableData> queue) {
  for (final t in queue) {
    if (t.status == 'running') return t;
  }
  for (final t in queue) {
    if (t.status == 'waiting') return t;
  }
  return null;
}
