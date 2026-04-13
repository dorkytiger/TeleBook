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
        return ListView.separated(
          padding: EdgeInsets.all(16),
          separatorBuilder: (context, index) {
            return SizedBox(height: 16);
          },
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

            return InkWell(
              onTap: onTap,
              onLongPress: onLongTap,
              borderRadius: BorderRadius.circular(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 封面
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.file(
                        File(
                          controller.pathService.getBookFilePath(
                            bookData.book.localPaths.first,
                          ),
                        ),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.broken_image, size: 40),
                        ),
                      ),
                    ),
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
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    bookData.collection!.name,
                                    style: Theme.of(context).textTheme.bodySmall
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
                                  style: Theme.of(context).textTheme.labelSmall
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
                  // 操作按钮
                  _buildEditPopupButton(
                    context,
                    bookData.book,
                    isVerticalLayout: true,
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

  Widget _buildBookGrid() {
    return controller.getBookState.displaySuccess(
      successBuilder: (data) {
        return GridView.builder(
          padding: EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 0.65,
            crossAxisSpacing: 16,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.file(
                              File(
                                controller.pathService.getBookFilePath(
                                  bookData.book.localPaths.first,
                                ),
                              ),
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 40,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                );
                              },
                              fit: BoxFit.cover,
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
                  ),
                  SizedBox(height: 12),
                  // 信息区域
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 书名和操作按钮在同一行
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                bookData.book.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            _buildEditPopupButton(context, bookData.book),
                          ],
                        ),
                      ],
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
                  icon: Icon(Icons.folder),
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
                OutlinedButton.icon(
                  onPressed: () {
                    final selectedBooks = controller.selectedBookIds.toList();
                    if (selectedBooks.isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("请至少选择一本书籍")));
                      return;
                    }
                    _deleteBooksConfirm(context, selectedBooks);
                  },
                  label: Text("删除"),
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
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
      child: MenuAnchor(
        menuChildren: [
          MenuItemButton(
            leadingIcon: const Icon(Icons.grid_view),
            trailingIcon: controller.bookLayout.value == BookLayoutSetting.grid
                ? const Icon(Icons.check, size: 16)
                : null,
            onPressed: () {
              controller.bookLayout.value = BookLayoutSetting.grid;
            },
            child: const Text("网格布局"),
          ),
          MenuItemButton(
            leadingIcon: const Icon(Icons.list),
            trailingIcon: controller.bookLayout.value == BookLayoutSetting.list
                ? const Icon(Icons.check, size: 16)
                : null,
            onPressed: () {
              controller.bookLayout.value = BookLayoutSetting.list;
            },
            child: const Text("列表布局"),
          ),
          MenuItemButton(
            leadingIcon: const Icon(Icons.sort_by_alpha),
            trailingIcon:
                controller.sortBy.value.type == BookSortType.title &&
                    controller.sortBy.value.order == BookSortOrder.asc
                ? const Icon(Icons.check, size: 16)
                : null,
            onPressed: () {
              controller.sortBy.value = BookSort(
                type: BookSortType.title,
                order: BookSortOrder.asc,
              );
            },
            child: const Text("标题升序"),
          ),
          MenuItemButton(
            leadingIcon: const Icon(Icons.sort_by_alpha_outlined),
            trailingIcon:
                controller.sortBy.value.type == BookSortType.title &&
                    controller.sortBy.value.order == BookSortOrder.desc
                ? const Icon(Icons.check, size: 16)
                : null,
            onPressed: () {
              controller.sortBy.value = BookSort(
                type: BookSortType.title,
                order: BookSortOrder.desc,
              );
            },
            child: const Text("标题降序"),
          ),
          MenuItemButton(
            leadingIcon: const Icon(Icons.access_time),
            trailingIcon:
                controller.sortBy.value.type == BookSortType.addTime &&
                    controller.sortBy.value.order == BookSortOrder.asc
                ? const Icon(Icons.check, size: 16)
                : null,
            onPressed: () {
              controller.sortBy.value = BookSort(
                type: BookSortType.addTime,
                order: BookSortOrder.asc,
              );
            },
            child: const Text("添加时间升序"),
          ),
          MenuItemButton(
            leadingIcon: const Icon(Icons.access_time_outlined),
            trailingIcon:
                controller.sortBy.value.type == BookSortType.addTime &&
                    controller.sortBy.value.order == BookSortOrder.desc
                ? const Icon(Icons.check, size: 16)
                : null,
            onPressed: () {
              controller.sortBy.value = BookSort(
                type: BookSortType.addTime,
                order: BookSortOrder.desc,
              );
            },
            child: const Text("添加时间降序"),
          ),
        ],
        builder: (btnContext, menuController, child) => IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () => menuController.isOpen
              ? menuController.close()
              : menuController.open(),
        ),
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
      return MenuAnchor(
        alignmentOffset: Offset(-64, 0),
        menuChildren: [
          MenuItemButton(
            leadingIcon: const Icon(Icons.edit),
            onPressed: () {
              Get.toNamed(AppRoute.bookEdit, arguments: book.id);
            },
            child: const Text("编辑"),
          ),
          MenuItemButton(
            leadingIcon: const Icon(Icons.star),
            onPressed: () {
              _addBookToCollection(context, book);
            },
            child: const Text("收藏夹"),
          ),
          MenuItemButton(
            leadingIcon: const Icon(Icons.upload),
            onPressed: () {
              controller.exportBook(book);
            },
            child: const Text("导出"),
          ),
          MenuItemButton(
            leadingIcon: const Icon(Icons.bookmark),
            onPressed: () {
              _addBookToMarks(context, book);
            },
            child: const Text("书签"),
          ),
          MenuItemButton(
            leadingIcon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("确认删除"),
                    content: Text("确定要删除《${book.name}》吗？此操作无法撤销"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("取消"),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.deleteBook(book.id);
                          Get.back();
                        },
                        child: const Text("删除"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              "删除",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
        builder: (btnContext, menuController, child) => IconButton(
          icon: Icon(isVerticalLayout ? Icons.more_horiz : Icons.more_vert),
          onPressed: () => menuController.isOpen
              ? menuController.close()
              : menuController.open(),
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

  Future<void> _deleteBooksConfirm(
    BuildContext context,
    List<int> bookIds,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("确认删除"),
          content: Text("确定要删除选中的 ${bookIds.length} 本书籍吗？此操作无法撤销"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: Text("取消"),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: true);
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text("删除"),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      for (var id in bookIds) {
        await controller.deleteBook(id);
      }
      // 删除完成后退出批量编辑模式
      controller.triggerMultiEditMode(false);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("已删除 ${bookIds.length} 本书籍")));
      }
    }
  }
}
