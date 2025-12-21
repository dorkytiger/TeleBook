import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/service/toast_service.dart';
import 'package:tele_book/app/util/request_state.dart';

class BookScreen extends GetView<BookController> {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TDNavBar(
          title: '书籍管理',
          useDefaultBack: false,
          rightBarItems: [
            TDNavBarItem(
              icon: Icons.download,
              action: () {
                Get.toNamed("/download");
              },
            ),
            TDNavBarItem(
              icon: Icons.add,
              action: () {
                Get.toNamed("/book/form");
              },
            ),
          ],
        ),
        body: Obx(() => DisplayResult(
              state: controller.getBookState.value,
              onSuccess: (data) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return TDCell(
                      title: data[index].name,
                      leftIconWidget: SizedBox(
                        height: 100,
                        width: 80,
                        child: Image.file(File(
                            "${controller.appDirectory}/${data[index].localPaths.first}")),
                      ),
                      description: '共 ${data[index].localPaths.length} 页',
                      onClick: (cell) {
                        Get.toNamed('/book/page', arguments: data[index].id);
                      },
                    );
                  },
                  itemCount: data.length,
                );
              },
            )));
  }
}
