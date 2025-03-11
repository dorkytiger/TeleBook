import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wo_nas/app/view/widget/button/delete_button_widget.dart';

import '../book_controller.dart';

class BookBottomWidget extends GetView<BookController> {
  const BookBottomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                controller.toggleEditing(); // 退出编辑模式
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.cancel_outlined,
                    color: Colors.blue,
                  ),
                  Text(
                    "取消",
                    style: TextStyle(color: Colors.black54),
                  )
                ],
              ),
            ),
            deleteButtonWidget(context, () {
              controller.deleteBooks(); // 删除选中的书籍
            })
          ],
        ),
      ),
    );
  }
}
