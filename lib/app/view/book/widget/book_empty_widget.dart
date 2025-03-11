import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wo_nas/app/view/book/book_controller.dart';

import '../../home/controllers/home_controller.dart';

class BookEmptyWidget extends GetView<BookController> {
  const BookEmptyWidget({super.key});

  Widget _actionButton(
    String title,
    IconData icon,
    Function onPressed,
  ) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 130,
          child: ElevatedButton(
            onPressed: () {
              onPressed();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "暂无书籍",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            )),
        _actionButton("前往下载", Icons.download, () {
          Get.find<HomeController>().setCurrentPage(1);
        }),
        _actionButton("刷新页面", Icons.refresh, controller.getBookList),
      ],
    ));
  }
}
