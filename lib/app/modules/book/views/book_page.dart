import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/book_controller.dart';

class BookPage extends GetView<BookController> {
  const BookPage({Key? key}) : super(key: key);

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
            itemCount: controller.bookPageList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Expanded(
                    flex: 9,
                    child: GestureDetector(
                      onTap: () {
                        _showBottomSheet(context);
                      },
                      child: Image.file(File(controller.bookPageList[index])),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 80,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Obx(() =>  Slider(
                 value: controller.currentPage.value.toDouble(),
                 min: 0,
                 max: (controller.bookPageList.length-1).toDouble(),
                 onChanged: (value){
                   controller.currentPage.value=value.toInt();
                   controller.pageController.jumpToPage(value.toInt());
                 }))
            ],
          ),
        );
      },
    );
  }
}
