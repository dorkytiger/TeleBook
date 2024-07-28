import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wo_nas/app/model/vo/book_vo.dart';
import 'package:wo_nas/app/view/book/widget/book_card_widget.dart';
import 'package:wo_nas/app/view/book/widget/book_empty_widget.dart';

import '../controllers/book_controller.dart';
import '../widget/book_bottom_widget.dart';

class BookView extends GetView<BookController> {
  const BookView({Key? key}) : super(key: key);

  Widget _actionButton(String title, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.blue,
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.black54, fontSize: 15),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: const Text(
              '书库',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue,
            actions: [
              PopupMenuTheme(
                data: const PopupMenuThemeData(
                  color: Colors.white, // Set your desired background color here
                ),
                child: PopupMenuButton<String>(
                  offset: const Offset(0, 55),
                  icon: const Icon(
                    Icons.add,
                    size: 35,
                  ),
                  onSelected: (String result) {},
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                        onTap: () {
                          controller.getBookList();
                        },
                        value: "1",
                        child: _actionButton("刷新", Icons.refresh)),
                    PopupMenuItem<String>(
                        onTap: () {
                          controller.toggleEditing();
                        },
                        value: "2",
                        child: _actionButton("编辑", Icons.edit)),
                  ],
                ),
              ),
            ],
          ),
          body: RefreshIndicator(child: Obx(() {
            if (controller.bookList.isEmpty) {
              return const BookEmptyWidget();
            } else {
              return Obx(() => ListView.builder(
                    itemCount: controller.bookList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Obx(() => bookCardWidget(
                              controller.bookList[index],
                              controller.selectedItems.contains(index), () {
                            controller.onClickCard(index);
                          }, () {
                            controller.deleteBook(index);
                          }));
                    },
                  ));
            }
          }), onRefresh: () async {
            await controller.getBookList();
          }),
          bottomNavigationBar:
              controller.isEditing.value ? const BookBottomWidget() : null,
        ));
  }
}
