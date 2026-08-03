import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/empty_widget.dart';
import 'package:tele_book/common/widget/error_widget.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/collection/repository/collection_repository.dart';
import 'package:tele_book/feature/collection/ui/provider/collection_book_provider.dart';

class CollectionBookView extends ConsumerWidget {
  final int collectionId;

  const CollectionBookView({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(collectionBookViewProvider(collectionId));

    return FScaffold(
      header: FHeader.nested(
        title: Text("书籍列表"),
        prefixes: [
          FHeaderAction.back(
            onPress: () {
              context.pop();
            },
          ),
        ],
        suffixes: [
          FHeaderAction(
            icon: Icon(Icons.add),
            onPress: () async {
              final disabledBookIds =
                  asyncState.value?.books
                      .map((item) => item.book.id)
                      .toList() ??
                  <int>[];

              final result = await context.push<List<BookTableData>>(
                AppRoute.bookPicker,
                extra: disabledBookIds,
              );
              if (result != null && result.isNotEmpty) {
                await ref
                    .read(collectionRepositoryProvider)
                    .addBooksToCollection(
                      collectionId: collectionId,
                      bookIds: result.map((e) => e.id).toList(),
                    );
                showFToast(context: context, title: Text("添加书籍到收藏成功"));
              }
            },
          ),
        ],
      ),
      child: asyncState.when(
        data: (data) {
          if (data.books.isEmpty) {
            return Center(
              child: CustomEmptyWidget(icon: CupertinoIcons.book, text: "暂无书籍"),
            );
          }
          return FItemGroup.builder(
            count: data.books.length,
            itemBuilder: (context, index) {
              final item = data.books[index];
              return FItem(
                title: Text(
                  item.book.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                prefix: LocalImageWidget(imagePath: item.coverImagePath),
                subtitle: Text('共 ${item.book.localSubPaths.length} 页'),
                suffix: FButton.icon(
                  variant: .ghost,
                  onPress: () async {
                    final confirm = await showFDialog<bool>(
                      context: context,
                      builder: (context, style, animate) => FDialog.adaptive(
                        verticalBuilder: (context, style) {
                          return Padding(
                            padding: .all(16),
                            child: Column(
                              crossAxisAlignment: .start,
                              mainAxisSize: .min,
                              children: [
                                Text("确认删除吗？", style: style.titleTextStyle),
                                SizedBox(width: 8),
                                Text(
                                  "将从书架中移除该书籍，但不会删除本地文件",
                                  style: style.bodyTextStyle,
                                ),
                                SizedBox(width: 8),
                                Row(
                                  mainAxisAlignment: .end,
                                  children: [
                                    FButton(
                                      variant: .ghost,
                                      onPress: () =>
                                          Navigator.pop(context, false),
                                      child: Text("取消"),
                                    ),
                                    SizedBox(width: 8),
                                    FButton(
                                      variant: .destructive,
                                      onPress: () =>
                                          Navigator.pop(context, true),
                                      child: Text("确认"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        horizontalBuilder: (context, style) {
                          return Padding(
                            padding: .all(16),
                            child: Column(
                              crossAxisAlignment: .start,
                              mainAxisSize: .min,
                              children: [
                                Text("确认删除吗？", style: style.titleTextStyle),
                                SizedBox(width: 8),
                                Text(
                                  "将从书架中移除该书籍，但不会删除本地文件",
                                  style: style.bodyTextStyle,
                                ),
                                SizedBox(width: 8),
                                Row(
                                  mainAxisAlignment: .end,
                                  children: [
                                    FButton(
                                      variant: .ghost,
                                      onPress: () =>
                                          Navigator.pop(context, false),
                                      child: Text("取消"),
                                    ),
                                    SizedBox(width: 8),
                                    FButton(
                                      variant: .destructive,
                                      onPress: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text("确认"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                    if (confirm == true) {
                      await ref
                          .read(collectionRepositoryProvider)
                          .removeBookFromCollection(
                            collectionId: collectionId,
                            bookId: item.book.id,
                          );
                      showFToast(context: context, title: Text("删除收藏书籍成功"));
                    }
                  },
                  child: Icon(FLucideIcons.trash),
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: CustomErrorWidget(errorMessage: e.toString(), stackTrace: st),
        ),
      ),
    );
  }
}
