import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/error_widget.dart';
import 'package:tele_book/common/widget/f_sheet_content.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/parse/ui/provider/parse_batch_image_folder.dart';

class ParseBatchImageFolderView extends ConsumerStatefulWidget {
  final String? parentDirPath;
  final List<String>? imagePaths;

  const ParseBatchImageFolderView({
    super.key,
    this.parentDirPath,
    this.imagePaths,
  });

  @override
  ConsumerState<ParseBatchImageFolderView> createState() =>
      _ParseBatchImageFolderViewState();
}

class _ParseBatchImageFolderViewState
    extends ConsumerState<ParseBatchImageFolderView> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final param = ParseBatchImageFolderParam(
      parentDirPath: widget.parentDirPath,
      imagePaths: widget.imagePaths,
    );

    final parseProvider = parseBatchImageFolderProvider(param);
    final saveProvider = saveBatchAsBookProvider(param);
    final parseAsync = ref.watch(parseProvider);
    final parseNotifier = ref.read(parseProvider.notifier);
    final saveState = ref.watch(saveProvider);
    final saveNotifier = ref.read(saveProvider.notifier);

    ref.listen(saveBatchAsBookProvider(param).select((s) => s.submitState), (
      previous,
      next,
    ) {
      if (previous == null) return;
      if (next.hasError) {
        showFToast(
          context: context,
          title: Text("保存失败"),
          description: Text(e.toString()),
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
        title: const Text('批量解析文件夹'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
        suffixes: [
          if (parseAsync.value?.isParsing == false)
            FHeaderAction(
              icon: const Icon(FLucideIcons.refreshCw),
              onPress: () => parseNotifier.refresh(),
            ),
        ],
      ),
      child: parseAsync.when(
        error: (error, stack) => Center(
          child: CustomErrorWidget(
            errorMessage: error.toString(),
            stackTrace: stack,
          ),
        ),
        loading: () {
          final current = parseAsync.value;
          if (current != null && current.totalCount > 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const FCircularProgress(size: .xl),
                  const SizedBox(height: 8),
                  Text("正在处理：${current.completeCount}/${current.totalCount}"),
                  if (current.currentFileName.isNotEmpty)
                    Text("当前文件：${current.currentFileName}"),
                ],
              ),
            );
          }
          return const Center(child: FCircularProgress(size: .xl));
        },
        data: (state) {
          if (state.isParsing) {
            if (state.totalCount == 0 && state.completeCount == 0) {
              return const Center(child: FCircularProgress(size: .xl));
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const FCircularProgress(size: .xl),
                  const SizedBox(height: 8),
                  Text("正在处理：${state.completeCount}/${state.totalCount}"),
                  if (state.currentFileName.isNotEmpty)
                    Text("当前文件：${state.currentFileName}"),
                  if (state.currentFileProgressText.isNotEmpty)
                    Text(state.currentFileProgressText),
                ],
              ),
            );
          }

          if (state.parseBatchFolderList.isEmpty) {
            return const Center(child: Text('未解析到可用图片文件夹'));
          }

          return Column(
            children: [
              Expanded(
                child: FItemGroup(
                  children: [
                    for (var folder in state.parseBatchFolderList)
                      .item(
                        title: Text(folder.name),
                        subtitle: Text("图片数: ${folder.tempPaths.length}"),
                        prefix: LocalImageWidget(
                          imagePath: folder.tempPaths.first,
                        ),
                        suffix: const Icon(FLucideIcons.chevronRight),
                        onPress: () {
                          _buildImageList(
                            context,
                            folder.name,
                            folder.tempPaths,
                          );
                        },
                      ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: FButton(
                  onPress: saveState.submitState.isLoading
                      ? null
                      : () => saveNotifier.submit(
                          parseAsync.value!.parseBatchFolderList,
                        ),
                  child: saveState.submitState.isLoading
                      ? Text(
                          "正在保存：${saveState.saveAsBookCount}/${saveState.totalCount}",
                        )
                      : const Text("保存到书架"),
                ),
              ),
            ],
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
              mainAxisSize: .min,
              crossAxisAlignment: .start,
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
