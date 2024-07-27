import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/book_controller.dart';
import '../widget/book_bottom_widget.dart';
import '../widget/book_card_widget.dart';

class BookView extends GetView<BookController> {
  const BookView({Key? key}) : super(key: key);

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
            // actions: [
            //   PopupMenuButton<String>(
            //     offset: const Offset(0, 55),
            //     icon: const Icon(
            //       Icons.add,
            //       size: 35,
            //     ),
            //     onSelected: (String result) {},
            //     itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            //       PopupMenuItem<String>(
            //           value: '1',
            //           child: TextButton(
            //             onPressed: () {
            //               controller.toggleEditing();
            //             },
            //             child: Obx(() => Text(
            //                   controller.isEditing.value ? "退出编辑" : "编辑书库",
            //                   style: const TextStyle(
            //                       color: Colors.black54, fontSize: 15),
            //                 )),
            //           )),
            //       PopupMenuItem<String>(
            //           value: '2',
            //           child: TextButton(
            //               onPressed: () {
            //                 controller.setGridCount();
            //               },
            //               child: Obx(() => Text(
            //                     controller.isTwice.value ? "双行显示" : "三行显示",
            //                     style: const TextStyle(
            //                         color: Colors.black54, fontSize: 15),
            //                   )))),
            //     ],
            //   ),
            // ],
          ),
          body: RefreshIndicator(
              child: Obx(() => GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: controller.gridCount.value,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 5,
                        childAspectRatio:
                            controller.isShowTitle.value ? (2 / 3) : (3 / 4)),
                    itemCount: controller.bookList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return BookCardWidget(index: index);
                    },
                  )),
              onRefresh: () async {
                await controller.getBookList();
              }),
          bottomNavigationBar:
              controller.isEditing.value ? const BookBottomWidget() : null,
        ));
  }
}
