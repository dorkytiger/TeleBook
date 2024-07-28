import 'dart:io';

import 'package:flutter/material.dart';

Widget downloadCardPreviewWidget(int page, int state, String preview) {
  {
    if (page > 1) {
      return Image.file(File(preview));
    } else if (state == 1) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cancel_outlined,
            size: 30,
            color: Colors.grey,
          ),
          Text("请求失败"),
        ],
      );
    }
  }
}
