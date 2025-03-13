import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/book/view/book_page_binding.dart';
import 'package:tele_book/app/view/book/view/book_page_view.dart';
import 'package:tele_book/app/widget/custom_empty.dart';
import 'package:tele_book/app/widget/custom_error.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';
import 'package:tele_book/app/widget/custom_loading.dart';

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
        TDIcons.add,
        color: Colors.white,
      ),
      theme: TDFabTheme.primary,
      onClick: () {
        controller.resetState();
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return _addBookDialog(buildContext, controller);
          },
        );
      },
    );
  }

  Widget _bookList(BuildContext context, BookController controller) {
    return ListView(
      children: [
        TDCellGroup(
            cells: controller.bookEntityList.map((e) {
          final datetime = DateTime.parse(e.bookData.createTime);
          String formattedDate =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(datetime);

          return TDCell(
            title: e.bookData.name,
            descriptionWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TDText(
                  "下载时间：$formattedDate",
                  font: Font(size: 12, lineHeight: 28),
                  style: const TextStyle(color: Colors.grey),
                ),
                TDText(
                  "阅读进度:${e.bookData.readCount}/${e.bookData.imageUrls.length}",
                  font: Font(size: 12, lineHeight: 28),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            leftIconWidget: SizedBox(
                height: 100,
                width: 100,
                child: CustomImageLoader(
                    isLocal: e.bookData.isDownload,
                    networkUrl: e.bookData.imageUrls.firstOrNull ?? "",
                    localUrl: e.bookData.localPaths.firstOrNull ?? "")),
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
                  e.bookData.isDownload ? TDIcons.check : TDIcons.pending,
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
                    return _bookActionBottomSheet(context, controller, e);
                  }));
            },
          );
        }).toList())
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
}
