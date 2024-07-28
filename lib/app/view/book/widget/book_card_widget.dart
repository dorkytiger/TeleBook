import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wo_nas/app/view/widget/button/delete_button_widget.dart';

import '../../../model/vo/book_vo.dart';

Widget bookCardWidget(
    BookVO bookVO, bool isSelect, Function onTap, Function onDelete) {
  Widget description(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black45,
        fontSize: 16,
      ),
    );
  }

  Widget titleDescription(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Card(
        color: isSelect ? Colors.black12 : Colors.white,
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
                    titleDescription(bookVO.title),
                    description("${bookVO.pictures.length}页"),
                    description(DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(DateTime.parse(bookVO.createTime))),
                  ],
                )),
          ],
        )),
  );
}
