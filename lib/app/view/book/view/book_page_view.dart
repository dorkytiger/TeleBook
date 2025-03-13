import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:wo_nas/app/util/request_state.dart';
import 'package:wo_nas/app/view/book/view/book_page_controller.dart';

import '../book_controller.dart';

class BookPageView extends GetView<BookPageController> {
  const BookPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final book = controller.book;
    return Scaffold(
        appBar: TDNavBar(
          title: book.name,
        ),
        body: () {
          return Obx(() => DisplayResult(
              state: controller.getBookState.value,
              onError: (error) {
                return Center(
                  child: TDResult(
                    theme: TDResultTheme.error,
                    title: "加载失败",
                    description: error,
                  ),
                );
              },
              onLoading: () {
                return const Center(
                  child: TDLoading(size: TDLoadingSize.large),
                );
              },
              onSuccess: (value) {
                final urls =
                    value.isDownload ? value.localPaths : value.imageUrls;
                debugPrint("urls: $urls");
                return PageView.builder(
                    controller: controller.pageController,
                    itemCount: urls.length,
                    onPageChanged: (index) {},
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {},
                        child: value.isDownload
                            ? Image.file(File(urls[index]))
                            : Image.network(urls[index], loadingBuilder:
                                (context, widget, loadingProgress) {
                                if (loadingProgress == null) {
                                  return widget;
                                }
                                return const Center(
                                  child: TDLoading(size: TDLoadingSize.large),
                                );
                              }, errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Column(
                                    children: [
                                      TDResult(
                                        theme: TDResultTheme.error,
                                        title: "加载失败",
                                        description: error.toString(),
                                      ),
                                      TDButton(
                                        text: "重新加载",
                                        onTap: () {},
                                      )
                                    ],
                                  ),
                                );
                              }),
                      );
                    });
              }));
        }());
  }
}
