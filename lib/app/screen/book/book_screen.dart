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
            void onTap() {
              if (controller.multiEditMode.value) {
                controller.toggleSelectBook(bookData.book.id);
              } else {
                Get.toNamed(AppRoute.bookPage, arguments: bookData.book.id);
              }
            }

            void onLongTap() {
              if (!controller.multiEditMode.value) {
                controller.triggerMultiEditMode(true);
                controller.toggleSelectBook(bookData.book.id);
                _showBottomSheet(context);
              }
            }

            final leading = ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              child: Image.file(
                File(
                  controller.pathService.getBookFilePath(
                    bookData.book.localPaths.first,
                  ),
                ),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 40),
              ),
            );

            final title = Text(bookData.book.name);

            // 构建包含创建时间和标签的 subtitle
            final subTitle = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                // 创建时间
                Text(
                  '创建于: ${bookData.book.createdAt.year}-${bookData.book.createdAt.month.toString().padLeft(2, '0')}-${bookData.book.createdAt.day.toString().padLeft(2, '0')}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                // 标签信息 - 使用 tag 风格
                if (bookData.marks.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: bookData.marks.map((mark) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          mark.name,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            );

            return ListTile(
              onTap: onTap,
              onLongPress: onLongTap,
              leading: leading,
              title: title,
              subtitle: subTitle,
              trailing: _buildEditPopupButton(context, bookData.book,isVerticalLayout: true),
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
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 9 / 16,
            crossAxisSpacing: 8,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final bookData = data[index];
            return InkWell(
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      child: SizedBox(
                        width: double.infinity,
                        child: Image.file(
                          File(
                            controller.pathService.getBookFilePath(
                              bookData.book.localPaths.first,
                            ),
                          ),
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: Icon(Icons.broken_image, size: 40),
                            );
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  spacing: 4,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 书名
                                    Text(
                                      bookData.book.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                    // 标签信息 - 使用 tag 风格
                                    if (bookData.marks.isNotEmpty)
                                      Wrap(
                                        spacing: 3,
                                        runSpacing: 3,
                                        children: bookData.marks.take(2).map((mark) {
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              mark.name,
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 9,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                  ],
                                ),
                              ),

                              _buildEditPopupButton(context, bookData.book),
                            ],
                          ),

                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
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
                OutlinedButton.icon(
                  onPressed: () {
                    final selectedBooks = controller.selectedBookIds.toList();
                    if (selectedBooks.isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("请至少选择一本书籍")));
                      return;
                    } else {
                      controller.exportMultipleBooks();
                    }
                  },
                  label: Text("导出"),
                  icon: Icon(Icons.upload),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionPopupButton(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: PopupMenuButton(
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
      ),
    );
  }

  Widget _buildEditPopupButton(
    BuildContext context,
    BookTableData book, {
    bool isVerticalLayout = false,
  }) {
    return Obx(() {
      // 在批量选择模式下显示勾选框
      if (controller.multiEditMode.value) {
        final isSelected = controller.selectedBookIds.contains(book.id);
        return SizedBox(
          height: 40,
          width: 40,
          child: Checkbox(
            value: isSelected,
            onChanged: (value) {
              controller.toggleSelectBook(book.id);
            },
          ),
        );
      }

      // 正常模式下显示弹出菜单
      return SizedBox(
        height: 40,
        width: 40,
        child: PopupMenuButton(
          icon: Icon(isVerticalLayout ? Icons.more_vert : Icons.more_horiz),
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
            if (value == "delete") {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("确认删除"),
                    content: Text("确定要删除《${book.name}》吗？此操作无法撤销"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("取消"),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.deleteBook(book.id);
                          Get.back();
                        },
                        child: Text("删除"),
                      ),
                    ],
                  );
                },
              );
            }
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
                  children: [Icon(Icons.star), SizedBox(width: 8), Text("收藏夹")],
                ),
              ),
              PopupMenuItem(
                value: "export",
                child: Row(
                  children: [
                    Icon(Icons.upload),
                    SizedBox(width: 8),
                    Text("导出"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "mark",
                child: Row(
                  children: [
                    Icon(Icons.bookmark),
                    SizedBox(width: 8),
                    Text("书签"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "delete",
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 8),
                    Text("删除"),
                  ],
                ),
              ),
            ];
          },
        ),
      );
    });
  }

  Future<void> _addBookToCollection(
    BuildContext context,
    BookTableData book,
  ) async {
    // 获取当前书籍的收藏夹数据
    final bookVo = controller.getBookState.value.data.firstWhereOrNull(
      (vo) => vo.book.id == book.id,
    );

    final collection = await showDialog(
      context: context,
      builder: (context) {
        final selectedCollection = Rxn<CollectionTableData>(bookVo?.collection);

        return AlertDialog(
          title: Text("选择收藏夹"),
          content: Obx(() {
            final data = controller.collectionService.collections;
            return SingleChildScrollView(
              child: RadioGroup<CollectionTableData?>(
                onChanged: (value) {
                  selectedCollection.value = value;
                },
                groupValue: selectedCollection.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 移除收藏选项
                    RadioListTile<CollectionTableData?>(
                      value: null,
                      title: Text("不加入收藏夹"),
                      subtitle: selectedCollection.value == null
                          ? Text("当前状态", style: TextStyle(color: Colors.grey))
                          : null,
                    ),
                    Divider(),
                    // 收藏夹列表
                    ...data.map(
                      (collection) => RadioListTile<CollectionTableData?>(
                        value: collection,
                        title: Text(collection.name),
                        subtitle: selectedCollection.value?.id == collection.id
                            ? Text(
                                "当前收藏夹",
                                style: TextStyle(color: Colors.grey),
                              )
                            : null,
                      ),
                    ),
                  ],
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

    // 注意：这里需要处理 null 的情况，collection 可能是 null 也可能是未选择（对话框被取消）
    if (collection != null) {
      await controller.collectionService.updateBookCollection(
        collection.id,
        book.id,
      );
    } else if (collection == null && bookVo?.collection != null) {
      // 用户明确选择了"不加入收藏夹"，移除收藏
      await controller.collectionService.updateBookCollection(0, book.id);
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
              child: RadioGroup<CollectionTableData?>(
                onChanged: (value) {
                  selectedCollection.value = value;
                },
                groupValue: selectedCollection.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 移除收藏选项
                    RadioListTile<CollectionTableData?>(
                      value: null,
                      title: Text("不加入收藏夹"),
                    ),
                    Divider(),
                    // 收藏夹列表
                    ...data.map(
                      (collection) => RadioListTile<CollectionTableData?>(
                        value: collection,
                        title: Text(collection.name),
                      ),
                    ),
                  ],
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
          collection.id,
          id,
        );
      }
    } else if (collection == null) {
      // 用户选择了"不加入收藏夹"，移除所有选中书籍的收藏
      for (var id in bookIds) {
        await controller.collectionService.updateBookCollection(0, id);
      }
    }
  }

  Future<void> _addBookToMarks(BuildContext context, BookTableData book) async {
    // 获取当前书籍的标签数据
    final bookVo = controller.getBookState.value.data.firstWhereOrNull(
      (vo) => vo.book.id == book.id,
    );

    final marks = await showDialog(
      context: context,
      builder: (context) {
        // 预选当前已有的标签
        final selectedMarks = <int>{
          if (bookVo != null) ...bookVo.marks.map((mark) => mark.id),
        }.obs;

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
