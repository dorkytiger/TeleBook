import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/util/file_util.dart';
import 'package:tele_book/app/widget/custom_empty.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

import 'book_filter_controller.dart';

class BookFilterScreen extends StatelessWidget {
  final int? collectionId;

  const BookFilterScreen({super.key, this.collectionId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookFilterController(
        collectionId: collectionId,
        bookStore: context.read(),
        collectionStore: context.read(),
        markStore: context.read(),
      ),
      child: const BookFilterContent(),
    );
  }
}

class BookFilterContent extends StatelessWidget {
  const BookFilterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookFilterController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.getTitle()),
            actions: [
              IconButton(
                icon: Icon(
                  controller.bookLayout == BookLayoutSetting.grid
                      ? Icons.list
                      : Icons.grid_view,
                ),
                onPressed: () {
                  controller.bookLayout =
                      controller.bookLayout == BookLayoutSetting.grid
                      ? BookLayoutSetting.list
                      : BookLayoutSetting.grid;
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await controller.fetchBooks();
            },
            child: controller.bookLayout == BookLayoutSetting.list
                ? _buildBookList(controller)
                : _buildBookGrid(controller),
          ),
        );
      },
    );
  }

  Widget _buildBookList(BookFilterController controller) {
    return DKStateQueryDisplay(
      state: controller.getBookState,
      successBuilder: (data) {
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final bookData = data[index];

            return Card(
              margin: EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  context.push("${AppRoute.bookPage}?id=${bookData.book.id}");
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 封面
                      FutureBuilder<String>(
                        future: FileUtil.getBookImageFullPath(
                          bookData.book.localPaths.first,
                        ),
                        builder: (context, snapshot) {
                          return CustomImageLoader(localUrl: snapshot.data);
                        },
                      ),
                      SizedBox(width: 12),
                      // 信息区域
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 标题
                            Text(
                              bookData.book.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            // 创建时间
                            Text(
                              '创建于: ${bookData.book.createdAt.year}-${bookData.book.createdAt.month.toString().padLeft(2, '0')}-${bookData.book.createdAt.day.toString().padLeft(2, '0')}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withValues(alpha: 0.7),
                                  ),
                            ),
                            SizedBox(height: 6),
                            // 收藏夹信息
                            if (bookData.collection != null)
                              Padding(
                                padding: EdgeInsets.only(bottom: 6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.folder,
                                      size: 14,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        bookData.collection!.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // 标签信息
                            if (bookData.marks.isNotEmpty)
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: bookData.marks.map((mark) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      mark.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSecondaryContainer,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: data.length,
        );
      },
      emptyBuilder: () {
        return Center(child: CustomEmpty(message: "暂无书籍"));
      },
    );
  }

  Widget _buildBookGrid(BookFilterController controller) {
    return DKStateQueryDisplay(
      state: controller.getBookState,
      successBuilder: (data) {
        return GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 0.65,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final bookData = data[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  context.push("${AppRoute.bookPage}?id=${bookData.book.id}");
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 封面图片 (2:3 比例)
                    Expanded(
                      flex: 2,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: FutureBuilder(
                              future: FileUtil.getBookImageFullPath(
                                bookData.book.localPaths.first,
                              ),
                              builder: (context, snapshot) {
                                return CustomImageLoader(
                                  localUrl: snapshot.data,
                                );
                              },
                            ),
                          ),
                          // 右上角显示收藏夹和标签
                          if (bookData.collection != null ||
                              bookData.marks.isNotEmpty)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                spacing: 4,
                                children: [
                                  // 收藏夹图标
                                  if (bookData.collection != null)
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.2,
                                            ),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.folder,
                                        size: 16,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  // 标签指示器（显示数量）
                                  if (bookData.marks.isNotEmpty)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondaryContainer,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.2,
                                            ),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.bookmark,
                                            size: 12,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSecondaryContainer,
                                          ),
                                          SizedBox(width: 2),
                                          Text(
                                            '${bookData.marks.length}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondaryContainer,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // 信息区域
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 书名
                            Text(
                              bookData.book.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: data.length,
        );
      },
      emptyBuilder: () {
        return Center(child: CustomEmpty(message: "暂无书籍"));
      },
    );
  }
}
