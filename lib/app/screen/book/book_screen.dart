import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/service/toast_service.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/widget/td/td_cell_group_title_widge.dart';

class BookScreen extends GetView<BookController> {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(title: '书籍管理', useDefaultBack: false),
      body: Obx(
        () => Column(
          children: [
            if (controller.exportMultipleBookState.value.isLoading())
              Obx(
                () => TDCell(
                  title: "正在导出全部书籍，请稍候...",
                  descriptionWidget: TDProgress(
                    type: TDProgressType.linear,
                    value:
                        (controller.exportAllBookProgress /
                        controller.exportAllBookTotal.value),
                  ),
                ),
              ),
            Expanded(
              child: Obx(
                () => DisplayResult(
                  state: controller.getBookState.value,
                  onSuccess: (data) {
                    return Obx(() {
                      if (controller.bookLayout.value ==
                          BookLayoutSetting.list) {
                        return _buildBookList(data);
                      } else {
                        return _buildBookGrid(data);
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookList(List<BookTableData> data) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return TDCell(
          title: data[index].name,
          leftIconWidget: SizedBox(
            height: 100,
            width: 80,
            child: Image.file(
              File(
                "${controller.appDirectory}/${data[index].localPaths.first}",
              ),
            ),
          ),
          noteWidget: TDButton(
            size: TDButtonSize.small,
            icon: Icons.more_horiz,
            iconWidget: Icon(
              Icons.more_horiz,
              color: TDTheme.of(context).fontGyColor3,
              size: TDTheme.of(context).fontTitleLarge?.size,
            ),
            type: TDButtonType.text,
            onTap: () {
              _onMorePressed(context, data[index]);
            },
          ),
          description: '共 ${data[index].localPaths.length} 页',
          onClick: (cell) {
            Get.toNamed('/book/page', arguments: data[index].id);
          },
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
            Get.toNamed('/book/page', arguments: data[index].id);
          },
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
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: TDText(
                        data[index].name,
                        textColor: TDTheme.of(context).fontGyColor3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  TDButton(
                    size: TDButtonSize.small,
                    icon: Icons.more_horiz,
                    iconWidget: Icon(
                      Icons.more_horiz,
                      color: TDTheme.of(context).fontGyColor3,
                      size: TDTheme.of(context).fontBodyMedium?.size,
                    ),
                    type: TDButtonType.text,
                    onTap: () {
                      _onMorePressed(context, data[index]);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
      itemCount: data.length,
    );
  }

  void _onMorePressed(BuildContext context, BookTableData book) {
    TDActionSheet(
      context,
      visible: true,
      onSelected: (actionItem, actionIndex) async {
        if (actionIndex == 0) {
          Future.delayed(Duration(milliseconds: 100), () {
            Get.toNamed(AppRoute.bookEdit, arguments: book.id);
          });
        }
        if (actionIndex == 1) {
          controller.getCollections();
          Future.delayed(Duration(milliseconds: 100), () {
            Get.bottomSheet(
              Container(
                height: 400,
                color: Colors.white,
                child: _buildCollectionsList(context, book.id),
              ),
            );
          });
        }
        if (actionIndex == 2) {
          controller.exportSingleBook(book);
        }
        if (actionIndex == 3) {
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
        TDActionSheetItem(label: "编辑"),
        TDActionSheetItem(label: "加入到收藏夹"),
        TDActionSheetItem(label: "导出"),
        TDActionSheetItem(label: "刪除"),
      ],
    );
  }

  Widget _buildCollectionsList(BuildContext context, int bookId) {
    return Obx(
      () => DisplayResult(
        state: controller.getCollectionState.value,
        onSuccess: (data) {
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
      ),
    );
  }
}
