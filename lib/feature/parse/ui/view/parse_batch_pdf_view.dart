import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/feature/parse/model/parse_batch_archive_vo.dart';
import 'package:tele_book/feature/parse/ui/provider/parse_batch_pdf_provider.dart';

class ParseBatchPdfView extends ConsumerWidget {
  final String? pdfDirPath;
  final List<String>? pdfPaths;

  const ParseBatchPdfView({super.key, this.pdfDirPath, this.pdfPaths});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final param = ParseBatchPdfParam(
      pdfDirPath: pdfDirPath ?? '',
      pdfPaths: pdfPaths ?? [],
    );

    final asyncState = ref.watch(parseBatchPdfProvider(param));
    final parseProgress = ref.watch(parseBatchProgressProvider);

    final saveBatchBookState = ref.watch(parseBatchPdfSaveBookProvider);
    final saveBatchBookNotifier = ref.watch(
      parseBatchPdfSaveBookProvider.notifier,
    );
    final saveBookProgress = ref.watch(parseBatchPdfSaveBookProgressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('批量解析 PDF'), elevation: 0),
      body: asyncState.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 8),
              Text(
                '正在处理：${parseProgress.completeCount} / ${parseProgress.totalCount}',
              ),
              if (parseProgress.currentFileName.isNotEmpty)
                Text('当前文件：${parseProgress.currentFileName}'),
              Text("当前文件进度：${parseProgress.currentFileProgress}%"),
            ],
          ),
        ),
        error: (error, stack) => Center(child: Text(error.toString())),
        data: (state) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.parseBatchList.length,
          itemBuilder: (context, index) {
            final item = state.parseBatchList[index];
            return Row(
              children: [
                LocalImageWidget(imagePath: item.tempPaths.first),
                Expanded(
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text('页数：${item.tempPaths.length}'),
                    onTap: () => _showPagePreview(context, item),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: asyncState.hasValue
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: saveBatchBookState.isLoading == true
                    ? null
                    : () => saveBatchBookNotifier.saveBatchAsBook(
                        asyncState.value!.parseBatchList,
                      ),
                child: saveBatchBookState.isLoading == true
                    ? Text(
                        '正在保存：${saveBookProgress.current} / ${saveBookProgress.total}',
                      )
                    : const Text('保存到书架'),
              ),
            )
          : null,
    );
  }

  void _showPagePreview(BuildContext context, ParseBatchArchiveVo item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 1.0,
        expand: false,
        builder: (context, scrollController) => Column(
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
              '${item.name}（${item.tempPaths.length} 页）',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: MasonryGridView.count(
                controller: scrollController,
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                itemCount: item.tempPaths.length,
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.file(
                    File(item.tempPaths[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
