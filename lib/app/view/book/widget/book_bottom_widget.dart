import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/book_controller.dart';

class BookBottomWidget extends GetView<BookController>{
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
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text('确认删除'),
                      content: const Text(
                        '确定要删除选中的项吗？',
                        style: TextStyle(color: Colors.black54),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // 关闭对话框
                          },
                          child: const Text(
                            '取消',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            //controller.deleteSelectedItems();
                            Navigator.of(context).pop();
                            controller.toggleEditing();
                            controller.getBookList();
                            Get.forceAppUpdate();
                          },
                          child: const Text(
                            '确认删除',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.blue,
                  ),
                  Text(
                    "删除",
                    style: TextStyle(color: Colors.black54),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}