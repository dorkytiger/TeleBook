import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/book_controller.dart';

class BookPage extends GetView<BookController> {
  const BookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Obx(() => PageView.builder(
            itemCount: controller.bookPageList.length,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder<Uint8List>(
                future: controller.getCurrentBookPage(
                    controller.bookPageList[index], Get.arguments),
                builder:
                    (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("加载失败"));
                  } else if (snapshot.hasData) {
                    return Image.memory(snapshot.data!);
                  } else {
                    return const Center(child: Text("空白页"));
                  }
                },
              );
            })));
  }
}
