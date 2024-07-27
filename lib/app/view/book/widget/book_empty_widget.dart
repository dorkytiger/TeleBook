import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';


class BookEmptyWidget extends StatelessWidget {
  const BookEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "暂无书籍",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child:SizedBox(
            width: 130,
            child: ElevatedButton(
              onPressed: () {
                Get.find<HomeController>().setCurrentPage(1);
              },
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download),
                  Text(
                    "前往下载",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          )
        )
      ],
    ));
  }
}
