import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        color: Color.fromRGBO(0, 0, 0, 0.65),
        fontSize: 24,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Card(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.blueAccent,
        color: isSelect ? Colors.black12 : Colors.white,
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: SizedBox(
                  height: 130,
                  child: Image.file(
                    File(bookVO.preview),
                    fit: BoxFit.cover,
                    height: 130,
                  ),
                )),
            Expanded(
                flex: 1,
                child:Padding(padding:const EdgeInsets.all(16.0),child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    titleDescription(bookVO.title),
                    description("${bookVO.pictures.length}页"),
                    description(DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(DateTime.parse(bookVO.createTime))),
                  ],
                ))),
          ],
        )),
  );
}
