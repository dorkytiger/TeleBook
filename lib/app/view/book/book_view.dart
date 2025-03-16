import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/book/view/book_page_binding.dart';
import 'package:tele_book/app/view/book/view/book_page_view.dart';
import 'package:tele_book/app/widget/custom_empty.dart';
import 'package:tele_book/app/widget/custom_error.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';
import 'package:tele_book/app/widget/custom_loading.dart';

import 'book_controller.dart';

class BookView extends GetView<BookController> {
  const BookView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            onSuccess: (value) => _bookList(context, value));
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

  Widget _bookList(BuildContext context, List<BookTableData> bookList) {
    return ListView(
      children: [
        TDCellGroup(
            cells: bookList.map((e) {
          final datetime = DateTime.parse(e.createTime);
          String formattedDate =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(datetime);

          return TDCell(
            title: e.name,
            description: formattedDate,
            leftIconWidget: SizedBox(
                height: 100,
                width: 100,
                child: CustomImageLoader(
                    isLocal: e.isDownload,
                    networkUrl: e.imageUrls.firstOrNull ?? "",
                    localUrl: e.localPaths.firstOrNull ?? "")),
            rightIcon: e.isDownload ? TDIcons.check : null,
            onClick: (TDCell cell) {
              Get.to(() => const BookPageView(),
                  arguments: {
                    'book': e,
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

  Widget _bookActionBottomSheet(BuildContext context, BookController controller,
      BookTableData bookTableData) {
    return TDPopupBottomDisplayPanel(
        title: "书籍操作",
        child: TDCellGroup(
          cells: [
            bookTableData.isDownload
                ? TDCell(
                    title: "移除下载",
                    leftIcon: TDIcons.file_download,
                    onClick: (TDCell cell) {
                      controller.deleteDownload(bookTableData);
                      Navigator.of(context).pop();
                    },
                  )
                : TDCell(
                    title: "下载",
                    leftIcon: TDIcons.download,
                    onClick: (TDCell cell) {
                      controller.downLoadBook(bookTableData);
                      Navigator.of(context).pop();
                    },
                  ),
            TDCell(
              title: "删除",
              leftIcon: TDIcons.delete,
              onClick: (TDCell cell) {
                controller.deleteBook(bookTableData.id);
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
