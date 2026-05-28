import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/error_widget.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/parse/ui/provider/parse_batch_image_folder.dart';

class ParseBatchImageFolderView extends ConsumerWidget {
  final String? parentDirPath;
  final List<String>? imagePaths;

  const ParseBatchImageFolderView({
    super.key,
    this.parentDirPath,
    this.imagePaths,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final param = ParseBatchImageFolderParam(
      parentDirPath: parentDirPath,
      imagePaths: imagePaths,
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
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("保存失败：${next.error}")));
      } else if (previous?.isLoading == true &&
          next.isLoading == false &&
          next.error == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("保存成功！")));
        context.go(AppRoute.main);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('批量解析文件夹'), elevation: 0),
      body: parseAsync.when(
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
                  const CircularProgressIndicator(),
                  const SizedBox(height: 8),
                  Text("正在处理：${current.completeCount}/${current.totalCount}"),
                  if (current.currentFileName.isNotEmpty)
                    Text("当前文件：${current.currentFileName}"),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
        data: (state) {
          if (state.isParsing) {
            if (state.totalCount == 0 && state.completeCount == 0) {
              return const Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
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

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.parseBatchFolderList.length,
            itemBuilder: (context, index) {
              final folder = state.parseBatchFolderList[index];
              return Row(
                children: [
                  LocalImageWidget(imagePath: folder.tempPaths.first),
                  Expanded(
                    child: ListTile(
                      title: Text(folder.name),
                      subtitle: Text("图片数: ${folder.tempPaths.length}"),
                      onTap: () {
                        _buildImageList(context, folder.tempPaths);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar:
          parseAsync.value?.parseBatchFolderList.isNotEmpty == true
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: saveState.submitState.isLoading
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
            )
          : null,
      floatingActionButton: parseAsync.value?.isParsing == false
          ? FloatingActionButton(
              onPressed: () {
                parseNotifier.refresh();
              },
              child: const Icon(Icons.refresh),
            )
          : null,
    );
  }

  void _buildImageList(BuildContext context, List<String> imageList) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 1.0,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  "包含图片（${imageList.length}）",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: MasonryGridView.count(
                    controller: scrollController,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    itemCount: imageList.length,
                    itemBuilder: (context, index) {
                      final path = imageList[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.file(File(path), fit: BoxFit.cover),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
