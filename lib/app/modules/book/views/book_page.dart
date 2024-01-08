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
        body: Obx(() => PageView.builder(
            itemCount: controller.bookPageList.length,
            itemBuilder: (BuildContext context, int index) {
              print(controller.bookPageList[index]);
              return Image.file(File(controller.bookPageList[index]));
            })));
  }
}
