import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text("书籍列表"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final disabledBookIds = asyncState.value?.books
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
              }
            },
          ),
        ],
      ),
      body: asyncState.when(
        data: (data) {
          if (data.books.isEmpty) {
            return Center(
              child: CustomEmptyWidget(icon: CupertinoIcons.book, text: "暂无书籍"),
            );
          }
          return ListView.builder(
            itemCount: data.books.length,
            itemBuilder: (context, index) {
              final item = data.books[index];
              return GestureDetector(
                onTap: () => context.push(AppRoute.bookPage, extra: item.book),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      LocalImageWidget(imagePath: item.coverImagePath),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            item.book.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '共 ${item.book.localSubPaths.length} 页',
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("确认删除吗？"),
                                  content: Text("将从书架中移除该书籍，但不会删除本地文件"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text("取消"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text("确认"),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await ref
                                    .read(collectionRepositoryProvider)
                                    .removeBookFromCollection(
                                      collectionId: collectionId,
                                      bookId: item.book.id,
                                    );
                              }
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ),
                      ),
                    ],
                  ),
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
