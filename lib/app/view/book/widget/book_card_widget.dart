import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/book_controller.dart';
import '../views/book_page.dart';

class BookCardWidget extends GetView<BookController> {
  final int index;

  const BookCardWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          controller.currentBookIndex.value = index;
          await Get.to(() => const BookPage(),
              arguments: controller.bookList[index].pictures);
        },
        onLongPress: () {
          controller.toggleEditing();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Obx(() => Column(
                children: [
                  Expanded(
                    flex: 17,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned.fill(
                          child: Image.file(
                            File(controller.bookList[index].preview),
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (controller.isEditing.value)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  controller.toggleSelection(index);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        controller.selectedItems.contains(index)
                                            ? Colors.blue
                                            : Colors.white,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (controller.isShowTitle.value)
                    Obx(() => Expanded(
                          flex: 3,
                          child: Center(
                              child: Text(
                            controller.bookList[index].title,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                        ))
                ],
              )),
        ),
      ),
    );
  }
}
