import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/error_widget.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/parse/model/parse_batch_archive_vo.dart';
import 'package:tele_book/feature/parse/ui/provider/parse_batch_archive_provider.dart';

class ParseBatchArchiveView extends ConsumerWidget {
  final String? archiveDirPath;
  final List<String>? archivePaths;

  const ParseBatchArchiveView({
    super.key,
    this.archiveDirPath,
    this.archivePaths,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = parseBatchArchiveProvider(
      ParseBatchArchiveParam(
        archiveDirPath: archiveDirPath,
        archivePaths: archivePaths,
      ),
    );
    final asyncState = ref.watch(provider);
    final parseProgress = ref.watch(parseBatchArchiveProgressProvider);

    final saveState = ref.watch(parseBatchArchiveSaveBookProvider);
    final saveProgress = ref.watch(parseBatchArchiveSaveBookProgressProvider);
    final saveNotifier = ref.watch(parseBatchArchiveSaveBookProvider.notifier);

    ref.listen(parseBatchArchiveSaveBookProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败：${next.error}')));
      } else if (previous?.isLoading == true && next.hasValue) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('保存成功')));
        context.go(AppRoute.main);
      }
    });

    return _ParseBatchArchiveContentView(
      asyncState: asyncState,
      parseProgress: parseProgress,
      saveState: saveState,
      saveProgress: saveProgress,
      onSave: (data) => saveNotifier.saveBatchAsBook(data),
    );
  }
}

class _ParseBatchArchiveContentView extends StatelessWidget {
  final AsyncValue<ParseBatchArchiveState> asyncState;
  final ParseBatchArchiveProgress parseProgress;
  final AsyncValue<void> saveState;
  final ParseBatchArchiveSaveBookProgress saveProgress;
  final void Function(List<ParseBatchArchiveVo> data) onSave;

  const _ParseBatchArchiveContentView({
    required this.asyncState,
    required this.parseProgress,
    required this.saveState,
    required this.saveProgress,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('批量解析'), elevation: 0),
      body: asyncState.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Text('正���处理：${parseProgress.completeCount}/${parseProgress.totalCount}'),
              if (parseProgress.currentFileName.isNotEmpty)
                Text('当前文件：${parseProgress.currentFileName}'),
              if (parseProgress.currentFileProgressText.isNotEmpty)
                Text(parseProgress.currentFileProgressText),
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
          return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final archive = data[index];
                return Row(
                  children: [
                    LocalImageWidget(imagePath: archive.tempPaths.first),
                    Expanded(
                      child: ListTile(
                        title: Text(archive.name),
                        subtitle: Text('图片数: ${archive.tempPaths.length}'),
                        onTap: () {
                          _buildArchiveImageList(context, archive.tempPaths);
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
          asyncState.value?.parseBatchArchiveList.isNotEmpty == true
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: saveState.isLoading
                    ? null
                    : () => onSave(asyncState.value!.parseBatchArchiveList),
                child: saveState.isLoading
                    ? Text('正在保存：${saveProgress.current}/${saveProgress.total}')
                    : const Text('保存到书架'),
              ),
            )
          : null,
    );
  }

  void _buildArchiveImageList(BuildContext context, List<String> imageList) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许高度超过半屏
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
                // 拖动把手
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
                    // 列数
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    itemCount: imageList.length,
                    itemBuilder: (context, index) {
                      final path = imageList[index];
                      // Image.file 会根据图片真实宽高自适应，形成瀑布流效果
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
