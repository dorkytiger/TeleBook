import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/util/state_util.dart';
import 'package:tele_book/feature/parse/model/parse_batch_archive_vo.dart';
import 'package:tele_book/feature/parse/ui/viewmodel/parse_batch_pdf_viewmodel.dart';
import 'dart:io';

class ParseBatchPdfView extends StatelessWidget {
  final String pdfDirPath;

  const ParseBatchPdfView({super.key, required this.pdfDirPath});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ParseBatchPdfViewmodel(
        pdfDirPath: pdfDirPath,
        parsePdfService: context.read(),
        bookRepository: context.read(),
      ),
      child: const _ParseBatchPdfContent(),
    );
  }
}

class _ParseBatchPdfContent extends StatelessWidget {
  const _ParseBatchPdfContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ParseBatchPdfViewmodel>();

    return Scaffold(
      appBar: AppBar(title: const Text('批量解析 PDF'), elevation: 0),
      body: vm.parseBatchState.when<List<ParseBatchArchiveVo>>(
        loading: () {
          if (vm.totalCount == 0 && vm.completeCount == 0) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 8),
                Text('正在处理：${vm.completeCount} / ${vm.totalCount}'),
              ],
            ),
          );
        },
        success: (data) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
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
      bottomNavigationBar: vm.parseBatchState.isSuccess
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: vm.saveBatchAsBookState.isLoading
                    ? null
                    : () => vm.saveBatchAsBook(context),
                child: vm.saveBatchAsBookState.isLoading
                    ? Text(
                        '正在保存：${vm.saveAsBookCount} / ${vm.parseBatchList.length}',
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

