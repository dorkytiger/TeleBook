import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/f_sheet_content.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/feature/parse/model/parse_batch_archive_vo.dart';
import 'package:tele_book/feature/parse/ui/provider/parse_batch_pdf_provider.dart';

import '../../../../core/route/app_route.dart';

class ParseBatchPdfView extends ConsumerStatefulWidget {
  final String? pdfDirPath;
  final List<String>? pdfPaths;

  const ParseBatchPdfView({super.key, this.pdfDirPath, this.pdfPaths});

  @override
  ConsumerState<ParseBatchPdfView> createState() => _ParseBatchPdfViewState();
}

class _ParseBatchPdfViewState extends ConsumerState<ParseBatchPdfView> {
  late final ParseBatchPdfParam _param;

  @override
  void initState() {
    super.initState();
    _param = ParseBatchPdfParam(
      pdfDirPath: widget.pdfDirPath ?? '',
      pdfPaths: widget.pdfPaths,
    );
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(parseBatchPdfProvider(_param));
    final parseProgress = ref.watch(parseBatchProgressProvider);

    final saveBatchBookState = ref.watch(parseBatchPdfSaveBookProvider);
    final saveBatchBookNotifier = ref.watch(
      parseBatchPdfSaveBookProvider.notifier,
    );
    final saveBookProgress = ref.watch(parseBatchPdfSaveBookProgressProvider);

    ref.listen(parseBatchPdfSaveBookProvider, (previous, next) {
      if (previous == null) return;
      if (next.hasError) {
        showFToast(
          context: context,
          title: Text("保存失败"),
          description: Text(next.error.toString()),
        );
      } else if (previous.isLoading &&
          next.isLoading == false &&
          next.error == null) {
        showFToast(context: context, title: Text("保存成功！"));
        context.go(AppRoute.main);
      }
    });

    return FScaffold(
      header: FHeader.nested(
        title: const Text('批量解析 PDF'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: asyncState.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FCircularProgress(size: .xl),
              const SizedBox(height: 8),
              Text(
                '正在处理：${parseProgress.completeCount} / ${parseProgress.totalCount}',
              ),
              if (parseProgress.currentFileName.isNotEmpty)
                Text('当前文件：${parseProgress.currentFileName}'),
            ],
          ),
        ),
        error: (error, stack) => Center(child: Text(error.toString())),
        data: (state) {
          if (state.parseBatchList.isEmpty) {
            return const Center(child: Text('暂无可解析内容'));
          }

          return Column(
            children: [
              Expanded(
                child: FItemGroup(
                  children: [
                    for (var item in state.parseBatchList)
                      .item(
                        title: Text(item.name),
                        subtitle: Text('页数：${item.tempPaths.length}'),
                        prefix: LocalImageWidget(
                          imagePath: item.tempPaths.isEmpty ? '' : item.tempPaths.first,
                        ),
                        suffix: const Icon(FLucideIcons.chevronRight),
                        onPress: () {
                          _showPagePreview(context, item);
                        },
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: FButton(
                  onPress: saveBatchBookState.isLoading == true
                      ? null
                      : () => saveBatchBookNotifier.saveBatchAsBook(
                          asyncState.value!.parseBatchList,
                        ),
                  child: saveBatchBookState.isLoading == true
                      ? Text(
                          '正在保存：${saveBookProgress.current} / ${saveBookProgress.total}',
                        )
                      : const Text('保存全部'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPagePreview(BuildContext context, ParseBatchArchiveVo item) {
    showFSheet(
      context: context,
      side: .btt,
      mainAxisMaxRatio: null,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.8,
        builder: (context, scrollController) => ScrollConfiguration(
          behavior: ScrollConfiguration.of(
            context,
          ).copyWith(dragDevices: {.touch, .mouse, .trackpad}),
          child: FSheetContent(
            side: .btt,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                FSheetContent.title(context, item.name),
                FSheetContent.subTitle(context, "${item.tempPaths.length} 页"),
                const SizedBox(height: 8),
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 200,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                        ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    itemCount: item.tempPaths.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Image.file(
                              File(item.tempPaths[index]),
                              fit: BoxFit.cover,
                              cacheWidth: 300,
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
