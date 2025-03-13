import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:wo_nas/app/util/request_state.dart';
import 'package:wo_nas/app/view/book/view/book_page_binding.dart';
import 'package:wo_nas/app/view/book/view/book_page_view.dart';
import 'package:wo_nas/app/widget/custom_empty.dart';
import 'package:wo_nas/app/widget/custom_error.dart';
import 'package:wo_nas/app/widget/custom_image_loader.dart';
import 'package:wo_nas/app/widget/custom_loading.dart';

import 'book_controller.dart';

class BookView extends StatelessWidget {
  const BookView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookController());

    return Scaffold(
      appBar: const TDNavBar(
        useDefaultBack: false,
        title: '书库',
        centerTitle: true,
      ),
      floatingActionButton: _floatActionButtons(context, controller),
      body: RefreshIndicator(child: Obx(() {
        return DisplayResult(
            state: controller.getBookListState.value,
            onEmpty: () => const CustomEmpty(message: "暂无书籍"),
            onError: (error) =>
                CustomError(title: "获取书籍失败", description: error),
            onLoading: () => const CustomLoading(),
            onSuccess: (value) => Obx(() => _bookList(context, controller)));
      }), onRefresh: () async {
        await controller.getBookList();
      }),
    );
  }

  Widget _floatActionButtons(BuildContext context, BookController controller) {
    return TDFab(
      icon: const Icon(
        TDIcons.menu_application,
        color: Colors.white,
      ),
      theme: TDFabTheme.primary,
      onClick: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return Container(
                color: Colors.white,
                child: _actionButtonSheet(context, controller),
              );
            }));
      },
    );
  }

  Widget _actionButtonSheet(BuildContext context, BookController controller) {
    return TDCellGroup(cells: [
      TDCell(
        leftIcon: TDIcons.add,
        title: "添加书籍",
        onClick: (TDCell cell) {
          Navigator.of(context).pop();
          controller.resetState();
          showGeneralDialog(
              context: context,
              pageBuilder: (BuildContext buildContext,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return _addBookDialog(buildContext, controller);
              });
        },
      ),
      TDCell(
        leftIcon: TDIcons.search,
        title: "搜索数据",
        onClick: (TDCell cell) {
          Navigator.of(context).pop();
          showGeneralDialog(
              context: context,
              pageBuilder: (BuildContext buildContext,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return _searchBookDialog(context, controller);
              });
        },
      )
    ]);
  }

  Widget _bookList(BuildContext context, BookController controller) {
    return ListView(
      children: [
        TDCellGroup(
            cells: controller.bookEntityList
                .map((e) => TDCell(
                      title: e.bookData.name,
                      description:
                          "${DateTime.parse(e.bookData.createTime).year}年${DateTime.parse(e.bookData.createTime).month}月${DateTime.parse(e.bookData.createTime).day}日",
                      leftIconWidget: SizedBox(
                          height: 100,
                          width: 100,
                          child: e.bookData.isDownload
                              ? Image.file(File(e.bookData.localPaths.first))
                              : CustomImageLoader(
                                  url: e.bookData.imageUrls.first)),
                      rightIconWidget: () {
                        if (e.isDownloading) {
                          return SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                                color: TDTheme.of(context).brandNormalColor,
                                value: e.downloadProgress),
                          );
                        } else {
                          return Icon(
                            e.bookData.isDownload
                                ? TDIcons.check
                                : TDIcons.pending,
                            color: TDTheme.of(context).brandNormalColor,
                          );
                        }
                      }(),
                      onClick: (TDCell cell) {
                        Get.to(() => const BookPageView(),
                            arguments: {
                              'book': e.bookData,
                            },
                            binding: BookPageBinding());
                      },
                      onLongPress: (TDCell cell) {
                        Navigator.of(context).push(TDSlidePopupRoute(
                            modalBarrierColor: TDTheme.of(context).fontGyColor2,
                            slideTransitionFrom: SlideTransitionFrom.bottom,
                            builder: (context) {
                              return _bookActionBottomSheet(
                                  context, controller, e);
                            }));
                      },
                    ))
                .toList())
      ],
    );
  }

  Widget _bookActionBottomSheet(
      BuildContext context, BookController controller, BookEntity bookEntity) {
    return TDPopupBottomDisplayPanel(
        title: "书籍操作",
        child: TDCellGroup(
          cells: [
            bookEntity.bookData.isDownload
                ? TDCell(
                    title: "移除下载",
                    leftIcon: TDIcons.file_download,
                    onClick: (TDCell cell) {
                      controller.deleteDownload(bookEntity);
                      Navigator.of(context).pop();
                    },
                  )
                : TDCell(
                    title: "下载",
                    leftIcon: TDIcons.download,
                    onClick: (TDCell cell) {
                      controller.downLoadBook(bookEntity);
                      Navigator.of(context).pop();
                    },
                  ),
            TDCell(
              title: "删除",
              leftIcon: TDIcons.delete,
              onClick: (TDCell cell) {
                controller.deleteBook(bookEntity.bookData.id);
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  Widget _addBookDialog(BuildContext context, BookController controller) {
    return TDInputDialog(
      textEditingController: controller.urlTextController,
      title: "添加书籍",
      hintText: "请输入链接",
      showCloseButton: true,
      buttonWidget: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Obx(
            () => TDButton(
              width: double.infinity,
              disabled: controller.addBookState.value.isLoading(),
              theme: TDButtonTheme.primary,
              text: "添加",
              onTap: () async {
                await controller.addBook(() {
                  Navigator.of(context).pop();
                });
              },
            ),
          )),
    );
  }

  Widget _searchBookDialog(BuildContext context, BookController controller) {
    return TDInputDialog(
      textEditingController: controller.urlTextController,
      title: "搜索数据",
      hintText: "请输入关键词",
      showCloseButton: true,
      buttonWidget: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Obx(
            () => TDButton(
              width: double.infinity,
              disabled: controller.addBookState.value.isLoading(),
              theme: TDButtonTheme.primary,
              text: "搜索",
              onTap: () {},
            ),
          )),
    );
  }
}
