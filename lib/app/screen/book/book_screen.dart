import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/service/toast_service.dart';
import 'package:tele_book/app/util/request_state.dart';

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
            icon: Icons.more_horiz_outlined,
            action: () {
              TDActionSheet(
                context,
                visible: true,
                onSelected: (actionItem, actionIndex) {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (actionIndex == 0) {
                      Get.toNamed("/book/form");
                    }
                    if (actionIndex == 1) {
                      Get.toNamed("/download");
                    }
                    if (actionIndex == 2) {
                      if (controller.exportMultipleBookState.value
                          .isLoading()) {
                        ToastService.showText("已有导出任务在进行中，请稍候再试");
                        return;
                      }
                      controller.exportMultipleBooks();
                    }
                  });
                },
                items: [
                  TDActionSheetItem(label: '添加书籍'),
                  TDActionSheetItem(label: '下载列表'),
                  TDActionSheetItem(label: '导出全部书籍'),
                ],
              );
            },
          ),
        ],
      ),
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
                          description: '共 ${data[index].localPaths.length} 页',
                          onClick: (cell) {
                            Get.toNamed(
                              '/book/page',
                              arguments: data[index].id,
                            );
                          },
                          onLongPress: (cell) {
                            TDActionSheet(
                              context,
                              visible: true,
                              onSelected: (actionItem, actionIndex) {
                                if (actionIndex == 0) {
                                  controller.exportSingleBook(data[index]);
                                }
                                if (actionIndex == 1) {
                                  Future.delayed(
                                    const Duration(milliseconds: 100),
                                    () {
                                      Get.dialog(
                                        TDAlertDialog(
                                          title: "删除书籍",
                                          content:
                                              "确定要删除《${data[index].name}》吗？此操作不可撤销。",
                                          rightBtn: TDDialogButtonOptions(
                                            title: "刪除",
                                            theme: TDButtonTheme.danger,
                                            action: () {
                                              Get.back();
                                              controller.deleteBook(
                                                data[index].id,
                                              );
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
                                    },
                                  );
                                }
                              },
                              items: [
                                TDActionSheetItem(label: "导出"),
                                TDActionSheetItem(label: "刪除"),
                              ],
                            );
                          },
                        );
                      },
                      itemCount: data.length,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
