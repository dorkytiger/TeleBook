import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/util/state_util.dart';
import 'package:tele_book/feature/parse/model/parse_batch_archive_vo.dart';
import 'package:tele_book/feature/parse/ui/viewmodel/parse_batch_archive_viewmodel.dart';

class ParseBatchArchiveView extends StatelessWidget {
  final String? archiveDirPath;
  final List<String>? archivePaths;

  const ParseBatchArchiveView({
    super.key,
    this.archiveDirPath,
    this.archivePaths,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ParseBatchArchiveViewmodel(
        archiveDirPath: archiveDirPath,
        archivePaths: archivePaths,
        parseArchiveService: context.read(),
        bookRepository: context.read(),
      ),
      child: _ParseBatchArchiveContentView(),
    );
  }
}

class _ParseBatchArchiveContentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<ParseBatchArchiveViewmodel>();
    return Scaffold(
      appBar: AppBar(title: const Text('批量解析'), elevation: 0),
      body: viewmodel.parseBatchArchiveState.when<List<ParseBatchArchiveVo>>(
        loading: () {
          if (viewmodel.totalCount == 0 && viewmodel.completeCount == 0) {
            return Center(child: CircularProgressIndicator());
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text("正在处理：${viewmodel.completeCount}/${viewmodel.totalCount}"),
              ],
            ),
          );
        },
        success: (data) {
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final archive = data[index];
              return Row(
                children: [
                  LocalImageWidget(imagePath: archive.tempPaths.first),
                  Expanded(
                    child: ListTile(
                      title: Text(archive.name),
                      subtitle: Text("图片数: ${archive.tempPaths.length}"),
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
      bottomNavigationBar: viewmodel.parseBatchArchiveState.isSuccess
          ? Padding(
              padding: EdgeInsets.all(16),
              child: FilledButton(
                onPressed: viewmodel.saveBatchAsBookState.isLoading
                    ? null
                    : () => viewmodel.saveBatchAsBook(context),
                child: viewmodel.saveBatchAsBookState.isLoading
                    ? Text(
                        "正在保存：${viewmodel.saveAsBookCount}/${viewmodel.parseBatchArchiveList.length}",
                      )
                    : Text("保存到书架"),
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
