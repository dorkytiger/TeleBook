import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/extend/rx_extend.dart';

import 'parse_image_folder_controller.dart';

class ParseImageFolderScreen extends GetView<ParseImageFolderController> {
  const ParseImageFolderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('解析图片文件夹'),
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: controller.scanImageState.displaySuccess(
        successBuilder: (data) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 8),
                    Expanded(child: Text("找到 ${data.length} 张图片")),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final imageFile = data[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Image.file(imageFile, fit: BoxFit.contain),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: () {
                    controller.saveImagesToLocal();
                  },
                  icon: Icon(Icons.save),
                  label: Text("保存图片"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
