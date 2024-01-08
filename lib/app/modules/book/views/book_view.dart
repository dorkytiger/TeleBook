import 'dart:io';
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
          title: const Text(
            '书库',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
                onPressed: () {
                  controller.getBookList();
                },
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Enter Text'),
                          content: TextField(
                            controller: controller.urlController,
                            keyboardType: TextInputType.text,
                            autofocus: true,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: 'Enter some text...',
                              labelText: 'Enter text',
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                controller.getBook();
                                Navigator.of(context).pop(); // 关闭对话框并返回输入的文本
                              },
                            ),
                          ],
                        );
                      });
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ))
          ],
        ),
        body: Obx(() => RefreshIndicator(
            child: ListView.builder(
                itemCount: controller.bookPreviewList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () async {
                        await controller
                            .getBookPageList(controller.bookPathList[index]);
                        await Get.to(() => const BookPage(),
                            arguments: controller.bookNameList[index]);
                      },
                      child: SizedBox(
                        height: 150,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Image.file(
                                    File(controller.bookPreviewList[index]))),
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
            await  controller.getBookList();

              // controller.getPreview();
            })));
  }
}
