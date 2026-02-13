import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/constant/collection_constant.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/screen/book/widget/book_collection_picker_widget.dart';
import 'package:tele_book/app/screen/book/widget/book_filter_widget.dart';
import 'package:tele_book/app/widget/custom_empty.dart';
import 'package:tele_book/app/widget/custom_loading.dart';
import 'package:tele_book/app/widget/td/td_action_sheet_item_icon_widget.dart';

class BookScreen extends GetView<BookController> {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('书籍管理'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.6,
                    minChildSize: 0.3,
                    maxChildSize: 0.9,
                    expand: false,
                    builder: (context, scrollController) {
                      return BookFilterWidget(
                        scrollController: scrollController,
                      );
                    },
                  );
                },
              );
            },
            icon: Icon(Icons.filter_alt),
          ),
          PopupMenuButton(
            onSelected: (index) {
              if (index == "edit") {
                controller.triggerMultiEditMode(true);
              }
              if (index == "add") {
                Get.toNamed(AppRoute.bookForm);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "edit",
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text("批量操作"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "add",
                child: Row(
                  children: [Icon(Icons.add), SizedBox(width: 8), Text("添加书籍")],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: _buildFab(context),
      body: Column(
        children: [
          Expanded(
            child: controller.getBookState.displaySuccess(
              successBuilder: (data) {
                return Obx(() {
                  if (controller.bookLayout.value == BookLayoutSetting.list) {
                    return _buildBookList();
                  } else {
                    return _buildBookGrid();
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookList() {
    return FutureBuilder(
      future: controller.bookService.getBooksVO(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CustomLoading();
        final booksVO = snapshot.data!;
        return ListView.builder(
          itemBuilder: (context, index) {
            final bookData = booksVO[index];
            return Card(
              child: Row(
                children: [
                  SizedBox(
                    child: Image.file(
                      File(
                        "${controller.appDirectory}/${bookData.book.localPaths.first}",
                      ),
                      height: 150,
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        bookData.book.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            "阅读进度: ${((bookData.book.readCount / bookData.book.localPaths.length) * 100).toStringAsFixed(1)}%",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          if (bookData.collection != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 4,
                              children: [
                                Icon(
                                  CollectionConstant.iconList.firstWhere(
                                    (icon) =>
                                        icon.codePoint ==
                                        bookData.collection!.icon,
                                    orElse: () =>
                                        CollectionConstant.iconList.first,
                                  ),
                                  size: 12,
                                  color: Color(bookData.collection!.color),
                                ),
                                Text(bookData.collection!.name),
                              ],
                            ),
                          if (bookData.marks.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 4,
                              children: [
                                ...bookData.marks.map(
                                  (e) => Chip(label: Text(e.name)),
                                ),
                              ],
                            ),
                        ],
                      ),
                      trailing: _buildPopupButton(context, bookData.book),
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: booksVO.length,
        );
      },
    );
  }

  Widget _buildBookGrid() {
    return FutureBuilder(
      future: controller.bookService.getBooksVO(),
      builder: (context, snapShot) {
        if (!snapShot.hasData) return CustomLoading();
        final data = snapShot.data!;

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
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Image.file(
                        File(
                          "${controller.appDirectory}/${bookData.book.localPaths.first}",
                        ),
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image, size: 40);
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
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
                            "阅读进度: ${((bookData.book.readCount / bookData.book.localPaths.length) * 100).toStringAsFixed(1)}%",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                      _buildPopupButton(context, bookData.book),
                    ],
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

  Widget _buildFab(BuildContext context) {
    final isShowMore = false.obs;
    final isAllSelected = controller.isAllBooksSelected;

    return Obx(
      () => controller.multiEditMode.value
          ? (!isShowMore.value
                ? TDFab(
                    icon: Icon(
                      Icons.more_horiz,
                      color: TDTheme.of(context).fontWhColor1,
                    ),
                    theme: TDFabTheme.primary,
                    onClick: () {
                      _showBatchEditOptions(context);
                    },
                  )
                : Column(
                    children: [
                      TDFab(
                        icon: Icon(
                          isAllSelected ? Icons.deselect : Icons.select_all,
                          color: TDTheme.of(context).fontWhColor1,
                        ),
                        theme: TDFabTheme.primary,
                        onClick: () {
                          if (isAllSelected) {
                            controller.deselectAllBooks();
                          } else {
                            controller.selectAllBooks();
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      TDFab(
                        icon: Icon(
                          Icons.check,
                          color: TDTheme.of(context).fontWhColor1,
                        ),
                        onClick: () {
                          _onBatchEditConfirmedPressed(context);
                        },
                      ),
                      SizedBox(height: 12),
                      TDFab(
                        icon: Icon(
                          Icons.close,
                          color: TDTheme.of(context).fontWhColor1,
                        ),
                        theme: TDFabTheme.danger,
                        onClick: () {
                          controller.triggerMultiEditMode(false);
                        },
                      ),
                    ],
                  ))
          : SizedBox.shrink(),
    );
  }

  void _showBatchEditOptions(BuildContext context) {
    final isAllSelected = controller.isAllBooksSelected;

    TDActionSheet.showGridActionSheet(
      context,
      description: "批量操作选项",
      onSelected: (actionItem, actionIndex) async {
        if (actionIndex == 0) {
          // 全选/取消全选
          if (isAllSelected) {
            controller.deselectAllBooks();
          } else {
            controller.selectAllBooks();
          }
        }
        if (actionIndex == 1) {
          // 确认操作
          _onBatchEditConfirmedPressed(context);
        }
        if (actionIndex == 2) {
          // 取消
          controller.triggerMultiEditMode(false);
        }
      },
      items: [
        TDActionSheetItem(
          label: isAllSelected ? "取消全选" : "全选",
          icon: TDActionSheetItemIconWidget(
            iconData: isAllSelected ? Icons.deselect : Icons.select_all,
            bgColor: TDTheme.of(context).brandNormalColor,
          ),
          group: "操作",
        ),
        TDActionSheetItem(
          label: "添加到收藏夹",
          icon: TDActionSheetItemIconWidget(
            iconData: Icons.check,
            bgColor: TDTheme.of(context).successNormalColor,
          ),
          group: "操作",
        ),
        TDActionSheetItem(
          label: "导出",
          icon: TDActionSheetItemIconWidget(
            iconData: Icons.check,
            bgColor: TDTheme.of(context).successNormalColor,
          ),
          group: "操作",
        ),
        TDActionSheetItem(
          label: "取消",
          icon: TDActionSheetItemIconWidget(
            iconData: Icons.close,
            bgColor: TDTheme.of(context).errorNormalColor,
          ),
          group: "操作",
        ),
      ],
    );
  }

  void _onBatchEditConfirmedPressed(BuildContext context) {
    TDActionSheet.showGroupActionSheet(
      context,
      onSelected: (actionItem, actionIndex) async {
        if (actionIndex == 0) {
          Get.to(
            () => BookCollectionPickerWidget(),
            arguments: {"bookIds": controller.selectedBookIds.toList()},
          );
        }
        if (actionIndex == 1) {
          Future.delayed(const Duration(milliseconds: 100), () {
            controller.exportMultipleBooks();
          });
        }
        if (actionIndex == 2) {
          Future.delayed(const Duration(milliseconds: 100), () {
            Get.dialog(
              TDAlertDialog(
                title: "删除书籍",
                content:
                    "确定要删除所选的 ${controller.selectedBookIds.length} 本书籍吗？此操作不可撤销。",
                rightBtn: TDDialogButtonOptions(
                  title: "刪除",
                  theme: TDButtonTheme.danger,
                  action: () {
                    Get.back();
                    controller.deleteMultipleBooks();
                  },
                ),
                leftBtn: TDDialogButtonOptions(
                  title: "取消",
                  action: () {
                    Get.back();
                  },
                ),
              ),
            );
          });
        }
      },
      items: [
        TDActionSheetItem(
          label: "加入到收藏夹",
          icon: TDActionSheetItemIconWidget(
            iconData: Icons.star,
            bgColor: TDTheme.of(context).warningNormalColor,
          ),
          group: "操作",
        ),
        TDActionSheetItem(
          label: "导出",
          icon: TDActionSheetItemIconWidget(iconData: Icons.upload),
          group: "操作",
        ),

        TDActionSheetItem(
          label: "删除",
          icon: TDActionSheetItemIconWidget(
            iconData: Icons.delete,
            bgColor: TDTheme.of(context).errorNormalColor,
          ),
          group: "操作",
        ),
      ],
    );
  }

  Widget _buildPopupButton(BuildContext context, BookTableData book) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == "edit") {
          Get.toNamed(AppRoute.bookEdit, arguments: book.id);
        }
        if (value == "collection") {
          _addCollection(context, book);
        }
        if (value == "export") {
          controller.exportBook(book);
        }
        if (value == "mark") {
          _addMarks(context, book);
        }
        if (value == "delete") {
          Future.delayed(const Duration(milliseconds: 100), () {
            Get.dialog(
              TDAlertDialog(
                title: "删除书籍",
                content: "确定要删除《${book.name}》吗？此操作不可撤销。",
                rightBtn: TDDialogButtonOptions(
                  title: "刪除",
                  theme: TDButtonTheme.danger,
                  action: () {
                    Get.back();
                    controller.deleteBook(book.id);
                  },
                ),
                leftBtn: TDDialogButtonOptions(
                  title: "取消",
                  action: () {
                    Get.back();
                  },
                ),
              ),
            );
          });
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

  Future<void> _addCollection(BuildContext context, BookTableData book) async {
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

  Future<void> _addMarks(BuildContext context, BookTableData book) async {
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
}
