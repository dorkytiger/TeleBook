import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/common/widget/f_sheet_content.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/sync/datasource/sync_log_local_datasource.dart';
import 'package:tele_book/feature/sync/ui/view/sync_log_list_view.dart';

/// 同步记录详情：每本书的同步状态；点击书弹出每张图片的上传/下载进度。
class SyncLogDetailView extends ConsumerWidget {
  final int logId;

  const SyncLogDetailView({super.key, required this.logId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(syncLogDetailProvider(logId));

    return FScaffold(
      header: FHeader.nested(
        title: const Text('同步详情'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: log.when(
        loading: () => const Center(child: FCircularProgress()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (entry) {
          if (entry == null) {
            return const Center(child: Text('该记录不存在'));
          }
          final books = parseLogBooks(entry);
          if (books.isEmpty) {
            return const Center(child: Text('该记录没有书籍明细'));
          }
          return FItemGroup(
            children: [
              for (final book in books)
                .item(
                  prefix: LocalImageWidget(
                    imagePath: _bookCoverPath(book),
                    width: 48,
                    height: 64,
                  ),
                  title: Text(book.name),
                  subtitle: Text(
                    '图片 ${book.filesDone}/${book.files.length}'
                    '${book.filesFailed > 0 ? ' · 失败 ${book.filesFailed}' : ''}',
                  ),
                  suffix: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _bookStatusLabel(book.status),
                        style: context.theme.typography.body.sm.copyWith(
                          color: switch (book.status) {
                            'failed' => context.theme.colors.destructive,
                            'done' => context.theme.colors.primary,
                            _ => context.theme.colors.mutedForeground,
                          },
                        ),
                      ),

                      if (book.files.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 60,
                          child: FDeterminateProgress(
                            value: book.files.isEmpty
                                ? 0
                                : book.filesDone / book.files.length,
                          ),
                        ),
                      ],
                    ],
                  ),
                  onPress: book.files.isEmpty
                      ? null
                      : () => _showFileSheet(context, book),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showFileSheet(BuildContext context, SyncLogBookState book) {
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
              '图片 ${book.filesDone}/${book.files.length}'
              '${book.filesFailed > 0 ? ' · 失败 ${book.filesFailed}' : ''}',
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FItemGroup(
                children: [
                  for (final f in book.files)
                    .item(
                      prefix: LocalImageWidget(
                        imagePath: GlobalConfig.resolveBookPath(
                          '${book.uuid}/${f.rel}',
                        ),
                        width: 40,
                        height: 40,
                      ),
                      title: Text(f.rel),
                      suffix: Text(
                        _fileStatusLabel(f.status),
                        style: context.theme.typography.body.sm.copyWith(
                          color: switch (f.status) {
                            'failed' => context.theme.colors.destructive,
                            'done' => context.theme.colors.primary,
                            _ => context.theme.colors.mutedForeground,
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 书的封面本地路径（无封面则用第一张图）。
  String _bookCoverPath(SyncLogBookState book) {
    final rel = book.files.any((f) => f.rel == 'cover.jpg')
        ? 'cover.jpg'
        : (book.files.isNotEmpty ? book.files.first.rel : '');
    return rel.isEmpty ? '' : GlobalConfig.resolveBookPath('${book.uuid}/$rel');
  }

  String _bookStatusLabel(String status) => switch (status) {
    'done' => '已同步',
    'failed' => '失败',
    'syncing' => '同步中',
    _ => '等待',
  };

  String _fileStatusLabel(String status) => switch (status) {
    'done' => '已完成',
    'failed' => '失败',
    'syncing' => '上传中',
    _ => '等待',
  };
}

/// 监听单条同步记录：同步会话期间数据库持续更新（进度/状态），
/// StreamProvider 让详情页实时刷新；记录删除时返回 null。
final syncLogDetailProvider = StreamProvider.autoDispose
    .family<SyncLogTableData?, int>((ref, id) {
      return ref.watch(syncLogLocalDatasourceProvider).watchLog(id);
    });
