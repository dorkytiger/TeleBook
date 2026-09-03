import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/error_widget.dart';
import 'package:tele_book/common/widget/f_sheet_content.dart';
import 'package:tele_book/common/widget/f_text.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/parse/ui/provider/parse_batch_archive_provider.dart';

class ParseBatchArchiveView extends ConsumerStatefulWidget {
  final String? archiveDirPath;
  final List<String>? archivePaths;

  const ParseBatchArchiveView({
    super.key,
    this.archiveDirPath,
    this.archivePaths,
  });

  @override
  ConsumerState<ParseBatchArchiveView> createState() =>
      _ParseBatchArchiveViewState();
}

class _ParseBatchArchiveViewState extends ConsumerState<ParseBatchArchiveView> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = parseBatchArchiveProvider(
      ParseBatchArchiveParam(
        archiveDirPath: widget.archiveDirPath,
        archivePaths: widget.archivePaths,
      ),
    );
    final asyncState = ref.watch(provider);
    final parseProgress = ref.watch(parseBatchArchiveProgressProvider);

    ref.listen(parseBatchArchiveSaveBookProvider, (previous, next) {
      if (previous == null) return;
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败：${next.error}')));
      } else if (previous.isLoading && next.hasValue) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('保存成功')));
        context.go(AppRoute.main);
      }
    });

    return FScaffold(
      header: FHeader.nested(
        title: const Text('批量解析'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: asyncState.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FText.title(
                context,
                '正在处理：${parseProgress.completeCount}/${parseProgress.totalCount}',
              ),
              if (parseProgress.currentFileName.isNotEmpty)
                FText.subTitle(
                  context,
                  '当前文件：${parseProgress.currentFileName}',
                ),
              if (parseProgress.currentFileProgressText.isNotEmpty)
                FText.subTitle(context, parseProgress.currentFileProgressText),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: CustomErrorWidget(
            errorMessage: error.toString(),
            stackTrace: stack,
          ),
        ),
        data: (state) {
          final data = state.parseBatchArchiveList;
          if (data.isEmpty) {
            return const Center(child: Text('暂无可解析内容'));
          }

          return Builder(
            builder: (innerContext) => Column(
              children: [
                Expanded(
                  child: FItemGroup(
                    children: [
                      for (var archive in data)
                        .item(
                          title: Text(archive.name),
                          subtitle: Text('图片数: ${archive.tempPaths.length}'),
                          prefix: LocalImageWidget(
                            imagePath: archive.tempPaths.isEmpty
                                ? ''
                                : archive.tempPaths.first,
                          ),
                          suffix: const Icon(FLucideIcons.chevronRight),
                          onPress: () {
                            _buildImageList(
                              innerContext,
                              archive.name,
                              archive.tempPaths,
                            );
                          },
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Consumer(
                    builder: (context, ref, _) {
                      final asyncState = ref.watch(
                        parseBatchArchiveProvider(
                          ParseBatchArchiveParam(
                            archiveDirPath: widget.archiveDirPath,
                            archivePaths: widget.archivePaths,
                          ),
                        ),
                      );
                      final saveState = ref.watch(
                        parseBatchArchiveSaveBookProvider,
                      );
                      final saveProgress = ref.watch(
                        parseBatchArchiveSaveBookProgressProvider,
                      );
                      final saveNotifier = ref.watch(
                        parseBatchArchiveSaveBookProvider.notifier,
                      );
                      return FButton(
                        onPress: saveState.isLoading
                            ? null
                            : () => saveNotifier.saveBatchAsBook(
                                asyncState.value!.parseBatchArchiveList,
                              ),
                        child: saveState.isLoading
                            ? Text(
                                '正在保存：${saveProgress.current}/${saveProgress.total}',
                              )
                            : const Text('保存全部'),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _buildImageList(
    BuildContext context,
    String title,
    List<String> imageList,
  ) {
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
              mainAxisSize: .min,
              children: [
                FSheetContent.title(context, title),
                FSheetContent.subTitle(context, "包含图片（${imageList.length}）"),
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
                    itemCount: imageList.length,
                    itemBuilder: (context, index) {
                      final path = imageList[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Image.file(
                              File(path),
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
