import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/widget/custom_empty.dart';

class BookScreen extends GetView<BookController> {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: !controller.multiEditMode.value,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && controller.multiEditMode.value) {
            // 如果在批量编辑模式，退出模式而不是返回页面
            controller.triggerMultiEditMode(false);
            Get.back();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('书籍管理'),
            actions: [
              SearchAnchor(
                builder: (context, searchController) {
                  return IconButton(
                    onPressed: () {
                      searchController.openView();
                    },
                    icon: Icon(Icons.search),
                  );
                },
                suggestionsBuilder: (context, searchController) {
                  return controller.fetchSearchBook(searchController.text);
                },
              ),
              _buildActionPopupButton(context),
            ],
          ),
          body: Obx(() {
            return RefreshIndicator(
              onRefresh: () async {
                await controller.fetchBooks();
              },
              child: controller.bookLayout.value == BookLayoutSetting.list
                  ? _buildBookList()
                  : _buildBookGrid(),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBookList() {
    return controller.getBookState.displaySuccess(
      successBuilder: (data) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final bookData = data[index];
            return Obx(
              () => Card(
                shape: controller.selectedBookIds.contains(bookData.book.id)
                    ? RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: InkWell(
                  onTap: () {
                    if (controller.multiEditMode.value) {
                      controller.toggleSelectBook(bookData.book.id);
                    } else {
                      Get.toNamed(
                        AppRoute.bookPage,
                        arguments: bookData.book.id,
                      );
                    }
                  },
                  onLongPress: () {
                    if (!controller.multiEditMode.value) {
                      controller.triggerMultiEditMode(true);
                      controller.toggleSelectBook(bookData.book.id);
                      _showBottomSheet(context);
                    }
                  },
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Obx(
                          () => controller.multiEditMode.value
                              ? Checkbox(
                                  value: controller.selectedBookIds.contains(
                                    bookData.book.id,
                                  ),
                                  onChanged: (value) {
                                    if (value == true) {
                                      controller.toggleSelectBook(
                                        bookData.book.id,
                                      );
                                    } else {
                                      controller.toggleSelectBook(
                                        bookData.book.id,
                                      );
                                    }
                                  },
                                )
                              : SizedBox.shrink(),
                        ),

                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.file(
                            File(
                              controller.pathService.getBookFilePath(
                                bookData.book.localPaths.first,
                              ),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        bookData.book.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        '创建于: ${bookData.book.createdAt.year}-${bookData.book.createdAt.month.toString().padLeft(2, '0')}-${bookData.book.createdAt.day.toString().padLeft(2, '0')}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  _buildEditPopupButton(context, bookData.book),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 8,
                                  children: [
                                    if (bookData.marks.isNotEmpty)
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: [
                                          ...bookData.marks.map(
                                            (e) => Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(e.color),
                                                ),
                                                color: Color(
                                                  e.color,
                                                ).withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                e.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      color: Color(e.color),
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (bookData.collection != null)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          bookData.collection!.name,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelSmall,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: LinearProgressIndicator(
                                  value: bookData.book.localPaths.isEmpty
                                      ? 0
                                      : bookData.book.readCount /
                                            bookData.book.localPaths.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: data.length,
        );
      },
    );
  }

  Widget _buildBookGrid() {
    return controller.getBookState.displaySuccess(
      successBuilder: (data) {
        return GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final bookData = data[index];
            return Card(
              shape: controller.selectedBookIds.contains(bookData.book.id)
                  ? RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
              child: InkWell(
                onTap: () {
                  if (controller.multiEditMode.value) {
                    controller.toggleSelectBook(bookData.book.id);
                  } else {
                    Get.toNamed(AppRoute.bookPage, arguments: bookData.book.id);
                  }
                },
                onLongPress: () {
                  if (!controller.multiEditMode.value) {
                    controller.triggerMultiEditMode(true);
                    controller.toggleSelectBook(bookData.book.id);
                    _showBottomSheet(context);
                  }
                },
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        width: double.infinity,
                        child: Image.file(
                          File(
                            controller.pathService.getBookFilePath(
                              bookData.book.localPaths.first,
                            ),
                          ),
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image, size: 40);
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      bookData.book.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      '${bookData.book.createdAt.year}-${bookData.book.createdAt.month.toString().padLeft(2, '0')}-${bookData.book.createdAt.day.toString().padLeft(2, '0')}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                _buildEditPopupButton(context, bookData.book),
                              ],
                            ),
                            if (bookData.marks.isNotEmpty)
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: [
                                  ...bookData.marks.map(
                                    (e) => Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color(e.color),
                                        ),
                                        color: Color(e.color).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        e.name,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(e.color),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            Spacer(),
                            SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: bookData.book.localPaths.isEmpty
                                  ? 0
                                  : bookData.book.readCount /
                                        bookData.book.localPaths.length,
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
    );
  }

  void _showBottomSheet(BuildContext context) {
    PersistentBottomSheetController? bottomSheetController;
    bottomSheetController = showBottomSheet(
      enableDrag: false,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              spacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    bottomSheetController?.close();
                    controller.triggerMultiEditMode(false);
                  },
                  label: Text("取消"),
                  icon: Icon(Icons.close),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    controller.isAllBooksSelected
                        ? controller.toggleDeselectAllBooks()
                        : controller.toggleSelectAllBooks();
                  },
                  label: Text("全选/取消全选"),
                  icon: Icon(Icons.select_all),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    final selectedBooks = controller.selectedBookIds.toList();
                    if (selectedBooks.isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("请至少选择一本书籍")));
                      return;
                    }
                    _addBooksToCollection(context, selectedBooks);
                  },
                  label: Text("加入到收藏夹"),
                  icon: Icon(Icons.check),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    final selectedBooks = controller.selectedBookIds.toList();
                    if (selectedBooks.isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("请至少选择一本书籍")));
                      return;
                    }
                    _addBooksToMarks(context, selectedBooks);
                  },
                  label: Text("添加书签"),
                  icon: Icon(Icons.bookmark),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionPopupButton(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.filter_list),
      onSelected: (value) {
        if (value == "grid") {
          controller.bookLayout.value = BookLayoutSetting.grid;
        }
        if (value == "list") {
          controller.bookLayout.value = BookLayoutSetting.list;
        }
        if (value == "titleAsc") {
          controller.sortBy.value = BookSort(
            type: BookSortType.title,
            order: BookSortOrder.asc,
          );
        }
        if (value == "titleDesc") {
          controller.sortBy.value = BookSort(
            type: BookSortType.title,
            order: BookSortOrder.desc,
          );
        }
        if (value == "addTimeAsc") {
          controller.sortBy.value = BookSort(
            type: BookSortType.addTime,
            order: BookSortOrder.asc,
          );
        }
        if (value == "addTimeDesc") {
          controller.sortBy.value = BookSort(
            type: BookSortType.addTime,
            order: BookSortOrder.desc,
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: "grid",
            child: Row(
              spacing: 8,
              children: [
                Icon(Icons.grid_view),
                Text("网格布局"),
                if (controller.bookLayout.value == BookLayoutSetting.grid)
                  Icon(Icons.check, size: 16),
              ],
            ),
          ),
          PopupMenuItem(
            value: "list",
            child: Row(
              spacing: 8,
              children: [
                Icon(Icons.list),

                Text("列表布局"),

                if (controller.bookLayout.value == BookLayoutSetting.list)
                  Icon(Icons.check, size: 16),
              ],
            ),
          ),
          PopupMenuItem(
            value: "titleAsc",
            child: Row(
              spacing: 8,
              children: [
                Icon(Icons.sort_by_alpha),
                Text("标题升序"),
                if (controller.sortBy.value.type == BookSortType.title &&
                    controller.sortBy.value.order == BookSortOrder.asc)
                  Icon(Icons.check, size: 16),
              ],
            ),
          ),
          PopupMenuItem(
            value: "titleDesc",
            child: Row(
              spacing: 8,
              children: [
                Icon(Icons.sort_by_alpha_outlined),
                Text("标题降序"),
                if (controller.sortBy.value.type == BookSortType.title &&
                    controller.sortBy.value.order == BookSortOrder.desc)
                  Icon(Icons.check, size: 16),
              ],
            ),
          ),
          PopupMenuItem(
            value: "addTimeAsc",
            child: Row(
              spacing: 8,
              children: [
                Icon(Icons.access_time),
                Text("添加时间升序"),
                if (controller.sortBy.value.type == BookSortType.addTime &&
                    controller.sortBy.value.order == BookSortOrder.asc)
                  Icon(Icons.check, size: 16),
              ],
            ),
          ),
          PopupMenuItem(
            value: "addTimeDesc",
            child: Row(
              spacing: 8,
              children: [
                Icon(Icons.access_time_outlined),
                Text("添加时间降序"),
                if (controller.sortBy.value.type == BookSortType.addTime &&
                    controller.sortBy.value.order == BookSortOrder.desc)
                  Icon(Icons.check, size: 16),
              ],
            ),
          ),
        ];
      },
    );
  }

  Widget _buildEditPopupButton(BuildContext context, BookTableData book) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == "edit") {
          Get.toNamed(AppRoute.bookEdit, arguments: book.id);
        }
        if (value == "collection") {
          _addBookToCollection(context, book);
        }
        if (value == "export") {
          controller.exportBook(book);
        }
        if (value == "mark") {
          _addBookToMarks(context, book);
        }
        if (value == "delete") {}
      },

      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: "edit",
            child: Row(
              children: [Icon(Icons.edit), SizedBox(width: 8), Text("编辑")],
            ),
          ),
          PopupMenuItem(
            value: "collection",
            child: Row(
              children: [Icon(Icons.star), SizedBox(width: 8), Text("加入收藏夹")],
            ),
          ),
          PopupMenuItem(
            value: "export",
            child: Row(
              children: [Icon(Icons.upload), SizedBox(width: 8), Text("导出")],
            ),
          ),
          PopupMenuItem(
            value: "mark",
            child: Row(
              children: [
                Icon(Icons.bookmark),
                SizedBox(width: 8),
                Text("添加书签"),
              ],
            ),
          ),
          PopupMenuItem(
            value: "delete",
            child: Row(
              children: [Icon(Icons.delete), SizedBox(width: 8), Text("删除")],
            ),
          ),
        ];
      },
    );
  }

  Future<void> _addBookToCollection(
    BuildContext context,
    BookTableData book,
  ) async {
    final collection = await showDialog(
      context: context,
      builder: (context) {
        final selectedCollection = Rxn<CollectionTableData>();

        return AlertDialog(
          title: Text("选择收藏夹"),
          content: Obx(() {
            final data = controller.collectionService.collections;
            return SingleChildScrollView(
              child: RadioGroup<CollectionTableData>(
                onChanged: (value) {
                  selectedCollection.value = value;
                },
                groupValue: selectedCollection.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: data
                      .map(
                        (collection) => RadioListTile<CollectionTableData>(
                          value: collection,
                          selected:
                              selectedCollection.value?.id == collection.id,
                          title: Text(collection.name),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("取消"),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: selectedCollection.value);
              },
              child: Text("确定"),
            ),
          ],
        );
      },
    );
    if (collection != null) {
      await controller.collectionService.updateBookCollection(
        collection!.id,
        book.id,
      );
    }
  }

  Future<void> _addBooksToCollection(
    BuildContext context,
    List<int> bookIds,
  ) async {
    final collection = await showDialog(
      context: context,
      builder: (context) {
        final selectedCollection = Rxn<CollectionTableData>();

        return AlertDialog(
          title: Text("选择收藏夹"),
          content: Obx(() {
            final data = controller.collectionService.collections;
            return SingleChildScrollView(
              child: RadioGroup<CollectionTableData>(
                onChanged: (value) {
                  selectedCollection.value = value;
                },
                groupValue: selectedCollection.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: data
                      .map(
                        (collection) => RadioListTile<CollectionTableData>(
                          value: collection,
                          selected:
                              selectedCollection.value?.id == collection.id,
                          title: Text(collection.name),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("取消"),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: selectedCollection.value);
              },
              child: Text("确定"),
            ),
          ],
        );
      },
    );
    if (collection != null) {
      for (var id in bookIds) {
        await controller.collectionService.updateBookCollection(
          collection!.id,
          id,
        );
      }
    }
  }

  Future<void> _addBookToMarks(BuildContext context, BookTableData book) async {
    final marks = await showDialog(
      context: context,
      builder: (context) {
        final selectedMarks = <int>{}.obs;

        return AlertDialog(
          title: Text("选择标签"),
          content: Obx(() {
            final data = controller.markService.marks;
            if (data.isEmpty) {
              return CustomEmpty(message: "暂无标签");
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: data
                    .map(
                      (mark) => CheckboxListTile(
                        value: selectedMarks.contains(mark.id),
                        onChanged: (value) {
                          if (value == true) {
                            selectedMarks.add(mark.id);
                          } else {
                            selectedMarks.remove(mark.id);
                          }
                        },
                        title: Text(mark.name),
                      ),
                    )
                    .toList(),
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("取消"),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: selectedMarks.toList());
              },
              child: Text("确定"),
            ),
          ],
        );
      },
    );
    if (marks != null) {
      await controller.markService.updateBookMarks(book.id, marks);
    }
  }

  Future<void> _addBooksToMarks(BuildContext context, List<int> bookIds) async {
    final marks = await showDialog(
      context: context,
      builder: (context) {
        final selectedMarks = <int>{}.obs;

        return AlertDialog(
          title: Text("选择标签"),
          content: Obx(() {
            final data = controller.markService.marks;
            if (data.isEmpty) {
              return CustomEmpty(message: "暂无标签");
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: data
                    .map(
                      (mark) => CheckboxListTile(
                        value: selectedMarks.contains(mark.id),
                        onChanged: (value) {
                          if (value == true) {
                            selectedMarks.add(mark.id);
                          } else {
                            selectedMarks.remove(mark.id);
                          }
                        },
                        title: Text(mark.name),
                      ),
                    )
                    .toList(),
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("取消"),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: selectedMarks.toList());
              },
              child: Text("确定"),
            ),
          ],
        );
      },
    );
    if (marks != null) {
      for (var id in bookIds) {
        await controller.markService.updateBookMarks(id, marks);
      }
    }
  }
}
