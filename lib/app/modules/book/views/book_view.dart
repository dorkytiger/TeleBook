import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wo_nas/app/modules/book/views/book_page.dart';

import '../controllers/book_controller.dart';

class BookView extends GetView<BookController> {
  const BookView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BookView'),
          centerTitle: true,
        ),
        body: Obx(() => RefreshIndicator(
            child: ListView.builder(
                itemCount: controller.bookPreviewList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () async {
                        await controller
                            .getBookPageList(controller.bookPathList[index]);
                        await Get.to(() => const BookPage());
                      },
                      child: SizedBox(
                        height: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: FutureBuilder<Uint8List>(
                                future: controller.getPreview(
                                    controller.bookPreviewList[index]),
                                builder: (BuildContext context,
                                    AsyncSnapshot<Uint8List> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return const Center(child: Text("加载失败"));
                                  } else if (snapshot.hasData) {
                                    return Image.memory(snapshot.data!);
                                  } else {
                                    return const Center(child: Text("空白页"));
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(controller.bookNameList[index]),
                              ),
                            ),
                          ],
                        ),
                      ));
                }),
            onRefresh: () async {
              controller.getBookList();
              // controller.getPreview();
            })));
  }
}
