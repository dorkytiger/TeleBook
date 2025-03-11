import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wo_nas/app/db/app_database.dart';

import '../../../model/vo/book_vo.dart';

Widget bookCardWidget(
    BookTableData bookTableData, bool isSelect, Function onTap, Function onDelete) {
  Widget description(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black45,
        fontSize: 14,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget titleDescription(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color.fromRGBO(0, 0, 0, 0.65),
        fontSize: 22,
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
                    File(bookTableData.localPaths[0]),
                    fit: BoxFit.cover,
                    height: 130,
                  ),
                )),
            Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        titleDescription(bookTableData.name),
                        description("${bookTableData.localPaths.length}页"),
                        description("11"),
                      ],
                    ))),
          ],
        )),
  );
}
