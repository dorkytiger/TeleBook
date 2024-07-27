import 'package:flutter/material.dart';

class BookEmptyWidget extends StatelessWidget {
  const BookEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "暂无书籍,点击右下角",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
        Icon(
          Icons.download,
          color: Colors.black54,
        ),
        Text(
          "下载",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        )
      ],
    ));
  }
}
