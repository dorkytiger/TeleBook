import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/book_controller.dart';

class BookPageView extends GetView<BookController> {
  const BookPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Obx(
        () => PageView.builder(
            controller: controller.pageController,
            onPageChanged: (int page) {
              controller.currentPage.value = page;
            },
            itemCount: controller
                .bookList[controller.currentBookIndex.value].pictures.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Expanded(
                    flex: 9,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Obx(() => bottomSheet());
                          },
                        );
                      },
                      child: Image.file(File(controller
                          .bookList[controller.currentBookIndex.value]
                          .pictures[index])),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
        height: 80,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 9,
              child: Slider(
                  value: controller.currentPage.value.toDouble(),
                  min: 0,
                  max: (controller.bookList[controller.currentBookIndex.value]
                              .pictures.length -
                          1)
                      .toDouble(),
                  onChanged: (value) {
                    controller.currentPage.value = value.toInt();
                    controller.pageController.jumpToPage(value.toInt());
                  }),
            ),
            Expanded(
              flex: 1,
              child: Text(
                  "${controller.currentPage.value + 1}/${controller.bookList[controller.currentBookIndex.value].pictures.length}"),
            )
          ],
        ));
  }
}
