import 'dart:io';

import 'package:flutter/material.dart';

import '../../../model/vo/book_vo.dart';

Widget bookCardWidget(BookVO bookVO) {

  Widget actionButton(String title, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.blue,
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }

  Widget description(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 15,
      ),
    );
  }

  return Card(
    color: Colors.white,
    child: Row(
      children: [
        Expanded(
            flex: 1,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                // Adjust the padding value as needed
                child: SizedBox(
                  height: 130,
                  child: Image.file(
                    File(bookVO.preview),
                    height: 130,
                  ),
                ))),
        Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                description(
                  "书名: ${bookVO.title}",
                ),
                description("总页数: ${bookVO.pictures.length}"),
              ],
            )),
        Expanded(
            flex: 1,
            child: Column(
              children: [
                actionButton("删除", Icons.delete),
              ],
            ))
      ],
    ),
  );
}
