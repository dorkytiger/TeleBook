import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/screen/book/widget/book_collection_picker_widget.dart';
import 'package:tele_book/app/screen/book/widget/book_filter_widget.dart';
import 'package:tele_book/app/screen/book/widget/book_mark_picker_widget.dart';
import 'package:tele_book/app/widget/td/td_action_sheet_item_icon_widget.dart';

class BookScreen extends GetView<BookController> {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        backgroundColor: TDTheme.of(context).brandNormalColor,
        titleColor: TDTheme.of(context).whiteColor1,
        title: '书籍管理',
        useDefaultBack: false,
        rightBarItems: [
          TDNavBarItem(
            icon: Icons.search,
            iconColor: TDTheme.of(context).whiteColor1,
            action: () {
              controller.toggleShowSearchBar();
            },
          ),
          TDNavBarItem(
            icon: Icons.filter_alt,
            iconColor: TDTheme.of(context).whiteColor1,
            action: () {
              Navigator.of(context).push(
                TDSlidePopupRoute(
                  builder: (context) {
                    return BookFilterWidget();
                  },
                ),
              );
            },
          ),
          TDNavBarItem(
            icon: Icons.more_horiz,
            iconColor: TDTheme.of(context).whiteColor1,
            action: () {
              _onActionMorePressed(context);
            },
          ),
        ],
      ),
      floatingActionButton: Obx(
        () => controller.multiEditMode.value
            ? Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  TDFab(
                    icon: Icon(
                      Icons.checklist_sharp,
                      color: TDTheme.of(context).warningColor1,
                    ),
                    theme: TDFabTheme.primary,
                    onClick: () {
                      _onBatchEditConfirmedPressed(context);
                    },
                  ),
                  TDFab(
                    icon: Icon(
                      Icons.close,
                      color: TDTheme.of(context).warningColor1,
                    ),
                    theme: TDFabTheme.danger,
                    onClick: () {
                      controller.triggerMultiEditMode(false);
                    },
                  ),
                ],
              )
            : SizedBox.shrink(),
      ),
      body: Column(
        children: [
          Obx(
            () => controller.showSearchBar.value
                ? TDSearchBar(
                    placeHolder: "搜索书籍名称",
                    controller: controller.searchBarController,
                  )
                : SizedBox.shrink(),
          ),
          Expanded(
            child: controller.getBookState.displaySuccess(
              successBuilder: (data) {
                return Obx(() {
                  if (controller.bookLayout.value == BookLayoutSetting.list) {
                    return _buildBookList(data);
                  } else {
                    return _buildBookGrid(data);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookList(List<BookUIData> data) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final bookData = data[index];
        return Obx(
          () => TDCell(
            title: bookData.book.name,
            disabled: controller.multiEditMode.value,
            imageWidget: SizedBox(
              height: 100,
              width: 80,
              child: Image.file(
                File(
                  "${controller.appDirectory}/${bookData.book.localPaths.first}",
                ),
              ),
            ),
            noteWidget: controller.multiEditMode.value
                ? Padding(
                    padding: EdgeInsets.all(8),
                    child: TDCheckbox(
                      checked: controller.selectedBookIds.contains(
                        bookData.book.id,
                      ),
                      onCheckBoxChanged: (checked) {
                        controller.toggleSelectBook(bookData.book.id);
                      },
                    ),
                  )
                : TDButton(
                    size: TDButtonSize.small,
                    icon: Icons.more_horiz,
                    type: TDButtonType.text,
                    theme: TDButtonTheme.primary,
                    onTap: () {
                      _onBookMorePressed(context, bookData.book);
                    },
                  ),
            descriptionWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                if (bookData.marks.isNotEmpty)
                  Row(
                    spacing: 8,
                    children: [
                      ...bookData.marks.map(
                        (e) => TDTag(
                          e.name,
                          size: TDTagSize.small,
                          backgroundColor: Color(e.color),
                          textColor: Colors.white,
                          shape: TDTagShape.square,
                        ),
                      ),
                    ],
                  ),
                if (bookData.collection != null)
                  TDTag(
                    bookData.collection!.name,
                    shape: TDTagShape.square,
                    iconWidget: Icon(
                      IconData(
                        bookData.collection!.icon,
                        fontFamily: 'MaterialIcons',
                      ),
                      size: 14,
                      color: Colors.white,
                    ),
                    textColor: Colors.white,
                    backgroundColor: Color(bookData.collection!.color),
                    isOutline: true,
                  ),
                if (bookData.book.readCount == 0)
                  TDProgress(
                    type: TDProgressType.linear,
                    value:
                        bookData.book.readCount +
                        1 / bookData.book.localPaths.length,
                    showLabel: false,
                    strokeWidth: 3,
                  ),
              ],
            ),
            onClick: (cell) {
              Get.toNamed(AppRoute.bookPage, arguments: bookData.book.id);
            },
          ),
        );
      },
      itemCount: data.length,
    );
  }

  Widget _buildBookGrid(List<BookUIData> data) {
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
        return GestureDetector(
          onTap: () {
            Get.toNamed(AppRoute.bookPage, arguments: bookData.book.id);
          },
          child: Container(
            decoration: BoxDecoration(
              color: TDTheme.of(context).bgColorContainer,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Image.file(
                        File(
                          "${controller.appDirectory}/${bookData.book.localPaths.first}",
                        ),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      if (bookData.collection != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Color(bookData.collection!.color),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 2,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              IconData(
                                bookData.collection!.icon,
                                fontFamily: 'MaterialIcons',
                              ),
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            TDText(
                              bookData.book.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (bookData.marks.isNotEmpty)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 4,
                                children: [
                                  ...bookData.marks.map(
                                    (e) => TDTag(
                                      e.name,
                                      backgroundColor: Color(e.color),
                                      textColor: Colors.white,
                                      shape: TDTagShape.square,
                                      size: TDTagSize.small,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => controller.multiEditMode.value
                          ? Padding(
                              padding: EdgeInsets.all(8),
                              child: TDCheckbox(
                                checked: controller.selectedBookIds.contains(
                                  bookData.book.id,
                                ),
                                onCheckBoxChanged: (checked) {
                                  controller.toggleSelectBook(bookData.book.id);
                                },
                              ),
                            )
                          : TDButton(
                              size: TDButtonSize.small,
                              icon: Icons.more_vert,
                              theme: TDButtonTheme.primary,
                              type: TDButtonType.text,
                              onTap: () {
                                _onBookMorePressed(context, bookData.book);
                              },
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      itemCount: data.length,
    );
  }

  void _onActionMorePressed(BuildContext context) {
    TDActionSheet.showGridActionSheet(
      context,
      description: "选择一个操作",
      onSelected: (actionItem, actionIndex) async {
        if (actionIndex == 0) {
          controller.triggerMultiEditMode(true);
        }
        if (actionIndex == 1) {
          Future.delayed(Duration(milliseconds: 100), () {
            Get.toNamed(AppRoute.bookForm);
          });
        }
        if (actionIndex == 2) {
          Future.delayed(Duration(milliseconds: 100), () {
            Get.toNamed(AppRoute.download);
          });
        }
        if (actionIndex == 3) {
          Future.delayed(Duration(milliseconds: 100), () {
            Get.toNamed(AppRoute.export);
          });
        }
        if (actionIndex == 4) {
          Future.delayed(Duration(milliseconds: 100), () {
            Get.toNamed(AppRoute.collection);
          });
        }
        if (actionIndex == 5) {
          Future.delayed(Duration(milliseconds: 100), () {
            Get.toNamed(AppRoute.mark);
          });
        }
      },
      items: [
        TDActionSheetItem(
          label: "批量操作",
          icon: TDActionSheetItemIconWidget(iconData: Icons.edit),
          group: "操作",
        ),
        TDActionSheetItem(
          label: "添加书籍",
          icon: TDActionSheetItemIconWidget(iconData: Icons.add),
          group: "操作",
        ),
        TDActionSheetItem(
          label: "下载历史",
          icon: TDActionSheetItemIconWidget(iconData: Icons.download),
          group: "操作",
        ),
        TDActionSheetItem(
          label: "导出历史",
          icon: TDActionSheetItemIconWidget(iconData: Icons.import_export),
          group: "操作",
        ),
        TDActionSheetItem(
          label: "收藏夹管理",
          icon: TDActionSheetItemIconWidget(
            iconData: Icons.star,
            bgColor: TDTheme.of(context).warningNormalColor,
          ),
          group: "操作",
        ),
        TDActionSheetItem(
          label: "书签管理",
          icon: TDActionSheetItemIconWidget(
            iconData: Icons.bookmark,
            bgColor: TDTheme.of(context).successNormalColor,
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

  void _onBookMorePressed(BuildContext context, BookTableData book) {
    TDActionSheet.showGridActionSheet(
      context,
      description: "选择一个操作",
      onSelected: (actionItem, actionIndex) async {
        if (actionIndex == 0) {
          Future.delayed(Duration(milliseconds: 100), () {
            Get.toNamed(AppRoute.bookEdit, arguments: book.id);
          });
        }
        if (actionIndex == 1) {
          Future.delayed(Duration(milliseconds: 100), () {
            Get.to(
              () => BookCollectionPickerWidget(),
              arguments: {
                "bookIds": [book.id],
              },
            );
          });
        }
        if (actionIndex == 2) {
          controller.exportBook(book);
        }
        if (actionIndex == 3) {
          Future.delayed(Duration(milliseconds: 100), () {
            Get.to(
              () => BookMarkPickerWidget(),
              arguments: {
                "bookIds": [book.id],
              },
            );
          });
        }
        if (actionIndex == 4) {
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
      items: [
        TDActionSheetItem(
          label: "编辑",
          icon: TDActionSheetItemIconWidget(iconData: Icons.edit),
          group: "操作",
        ),
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
          label: "添加书签",
          icon: TDActionSheetItemIconWidget(
            iconData: Icons.bookmark,
            bgColor: TDTheme.of(context).successNormalColor,
          ),
          group: "操作",
        ),
        TDActionSheetItem(
          label: "刪除",
          icon: TDActionSheetItemIconWidget(
            iconData: Icons.delete,
            bgColor: TDTheme.of(context).errorNormalColor,
          ),
          group: "操作",
        ),
      ],
    );
  }
}
