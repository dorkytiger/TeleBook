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
import 'package:tele_book/app/screen/book/widget/book_mark_picker_widget.dart';

class BookScreen extends GetView<BookController> {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: '书籍管理',
        useDefaultBack: false,
        rightBarItems: [
          TDNavBarItem(
            iconWidget: Obx(
              () => Icon(
                color: TDTheme.of(context).brandNormalColor,
                controller.multiEditMode.value ? Icons.close : Icons.edit,
              ),
            ),
            action: () {
              controller.triggerMultiEditMode();
            },
          ),
          TDNavBarItem(
            iconWidget: Obx(
              () => Icon(
                color: TDTheme.of(context).brandNormalColor,
                controller.bookLayout.value == BookLayoutSetting.list
                    ? Icons.grid_view
                    : Icons.view_list,
              ),
            ),
            action: () {
              controller.triggerBookLayoutChange();
            },
          ),
          TDNavBarItem(
            icon: Icons.add,
            iconColor: TDTheme.of(context).brandNormalColor,
            action: () {
              Get.toNamed(AppRoute.bookForm);
            },
          ),
        ],
      ),
      floatingActionButton: Obx(
        () => controller.multiEditMode.value
            ? TDFab(
                icon: Icon(
                  Icons.checklist_sharp,
                  color: TDTheme.of(context).warningColor1,
                ),
                theme: TDFabTheme.primary,
                onClick: () {
                  _onBatchEditConfirmedPressed(context);
                },
              )
            : SizedBox.shrink(),
      ),
      body: controller.getBookState.displaySuccess(
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
    );
  }

  Widget _buildBookList(List<BookTableData> data) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Obx(
          () => TDCell(
            title: data[index].name,
            disabled: controller.multiEditMode.value,
            imageWidget: SizedBox(
              height: 100,
              width: 80,
              child: Image.file(
                File(
                  "${controller.appDirectory}/${data[index].localPaths.first}",
                ),
              ),
            ),
            noteWidget: controller.multiEditMode.value
                ? Padding(
                    padding: EdgeInsets.all(8),
                    child: TDCheckbox(
                      checked: controller.selectedBookIds.contains(
                        data[index].id,
                      ),
                      onCheckBoxChanged: (checked) {
                        controller.toggleSelectBook(data[index].id);
                      },
                    ),
                  )
                : TDButton(
                    size: TDButtonSize.small,
                    icon: Icons.more_horiz,
                    type: TDButtonType.text,
                    theme: TDButtonTheme.primary,
                    onTap: () {
                      _onMorePressed(context, data[index]);
                    },
                  ),
            description: '共 ${data[index].localPaths.length} 页',
            onClick: (cell) {
              Get.toNamed(AppRoute.bookPage, arguments: data[index].id);
            },
          ),
        );
      },
      itemCount: data.length,
    );
  }

  Widget _buildBookGrid(List<BookTableData> data) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Get.toNamed(AppRoute.bookPage, arguments: data[index].id);
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
                  child: Image.file(
                    File(
                      "${controller.appDirectory}/${data[index].localPaths.first}",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: TDText(
                          data[index].name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Obx(
                      () => controller.multiEditMode.value
                          ? Padding(
                              padding: EdgeInsets.all(8),
                              child: TDCheckbox(
                                checked: controller.selectedBookIds.contains(
                                  data[index].id,
                                ),
                                onCheckBoxChanged: (checked) {
                                  controller.toggleSelectBook(data[index].id);
                                },
                              ),
                            )
                          : TDButton(
                              size: TDButtonSize.small,
                              icon: Icons.more_vert,
                              theme: TDButtonTheme.primary,
                              type: TDButtonType.text,
                              onTap: () {
                                _onMorePressed(context, data[index]);
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

  void _onBatchEditConfirmedPressed(BuildContext context) {
    TDActionSheet.showGroupActionSheet(
      context,
      onSelected: (actionItem, actionIndex) async {
        if (actionIndex == 0) {
          Get.to(
            () => BookCollectionPickerWidget(
              onCollectionSelected: (data) {
                controller.addMultipleBooksToCollection(data.id);
              },
            ),
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
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: TDTheme.of(context).warningLightColor,
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.star,
              color: TDTheme.of(context).warningNormalColor,
            ),
          ),
          group: "操作",
        ),
        TDActionSheetItem(
          label: "导出",
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: TDTheme.of(context).brandLightColor,
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.file_upload,
              color: TDTheme.of(context).brandNormalColor,
            ),
          ),
          group: "操作",
        ),

        TDActionSheetItem(
          label: "删除",
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: TDTheme.of(context).errorLightColor,
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.delete,
              color: TDTheme.of(context).errorNormalColor,
            ),
          ),
          group: "操作",
        ),
      ],
    );
  }

  void _onMorePressed(BuildContext context, BookTableData book) {
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
          Get.to(
            () => BookCollectionPickerWidget(
              onCollectionSelected: (data) {
                controller.addBookToCollection(book.id, data.id);
              },
            ),
          );
        }
        if (actionIndex == 2) {
          controller.exportBook(book);
        }
        if (actionIndex == 3) {
          Future.delayed(Duration(milliseconds: 100), () {
            Get.to(() => BookMarkPickerWidget());
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
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: TDTheme.of(context).brandLightColor,
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.edit,
              color: TDTheme.of(context).brandNormalColor,
            ),
          ),
          group: "操作",
        ),
        TDActionSheetItem(
          label: "加入到收藏夹",
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: TDTheme.of(context).warningLightColor,
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.star,
              color: TDTheme.of(context).warningNormalColor,
            ),
          ),
          group: "操作",
        ),
        TDActionSheetItem(
          label: "导出",
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: TDTheme.of(context).brandLightColor,
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.upload,
              color: TDTheme.of(context).brandNormalColor,
            ),
          ),
          group: "操作",
        ),
        TDActionSheetItem(
          label: "添加书签",
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: TDTheme.of(context).brandLightColor,
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.bookmark,
              color: TDTheme.of(context).brandNormalColor,
            ),
          ),
          group: "操作",
        ),
        TDActionSheetItem(
          label: "刪除",
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: TDTheme.of(context).errorLightColor,
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.delete,
              color: TDTheme.of(context).errorNormalColor,
            ),
          ),
          group: "操作",
        ),
      ],
    );
  }

  Widget _buildCollectionsList(BuildContext context, int bookId) {
    return controller.getCollectionState.displaySuccess(
      successBuilder: (data) {
        return TDPopupBottomDisplayPanel(
          backgroundColor: TDTheme.of(context).bgColorPage,
          title: "选择收藏夹",
          closeClick: () {
            Get.back();
          },
          child: TDCellGroup(
            theme: TDCellGroupTheme.cardTheme,
            cells: [
              ...data.map(
                (collection) => TDCell(
                  title: collection.name,
                  onClick: (cell) {
                    controller.addBookToCollection(bookId, collection.id);
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
