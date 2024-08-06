import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wo_nas/app/model/vo/book_vo.dart';

Widget bookPageWidget(
  BookVO bookVO,
) {
  PageController pageController = PageController();

  final int pageSize = bookVO.pictures.length;

  Widget showBottomSheet() {
    return Container(
        height: 80,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 9,
              child: Slider(
                  value: pageSize.toDouble(),
                  min: 0,
                  max: (pageSize - 1).toDouble(),
                  onChanged: (value) {
                    pageController.jumpToPage(value.toInt());
                  }),
            ),
            Expanded(
              flex: 1,
              child: Text("${pageController.page}/$pageSize"),
            )
          ],
        ));
  }

  return Scaffold(
    appBar: AppBar(),
    body: PageView.builder(
        controller: pageController,
        itemCount: pageSize,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Expanded(
                flex: 9,
                child: GestureDetector(
                  onTap: () {
                    showBottomSheet();
                  },
                  child: Image.file(File(bookVO.pictures[index])),
                ),
              ),
            ],
          );
        }),
  );
}
