import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/util/state_util.dart';
import 'package:tele_book/feature/parse/model/parse_batch_archive_vo.dart';
import 'package:tele_book/feature/parse/ui/viewmodel/parse_batch_image_folder_viewmodel.dart';

class ParseBatchImageFolderView extends StatelessWidget {
  final String parentDirPath;

  const ParseBatchImageFolderView({super.key, required this.parentDirPath});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ParseBatchImageFolderViewmodel(
        parentDirPath: parentDirPath,
        parseArchiveService: context.read(),
        bookRepository: context.read(),
      ),
      child: const _ParseBatchImageFolderContentView(),
    );
  }
}

class _ParseBatchImageFolderContentView extends StatelessWidget {
  const _ParseBatchImageFolderContentView();

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<ParseBatchImageFolderViewmodel>();
    return Scaffold(
      appBar: AppBar(title: const Text('批量解析文件夹'), elevation: 0),
      body: viewmodel.parseBatchFolderState.when<List<ParseBatchArchiveVo>>(
        loading: () {
          if (viewmodel.totalCount == 0 && viewmodel.completeCount == 0) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 8),
                Text("正在处理：${viewmodel.completeCount}/${viewmodel.totalCount}"),
              ],
            ),
          );
        },
        success: (data) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final folder = data[index];
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
      bottomNavigationBar: viewmodel.parseBatchFolderState.isSuccess
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: viewmodel.saveBatchAsBookState.isLoading
                    ? null
                    : () => viewmodel.saveBatchAsBook(context),
                child: viewmodel.saveBatchAsBookState.isLoading
                    ? Text(
                        "正在保存：${viewmodel.saveAsBookCount}/${viewmodel.parseBatchFolderList.length}",
                      )
                    : const Text("保存到书架"),
              ),
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

