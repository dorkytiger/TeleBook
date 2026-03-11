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
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "找到 ${data.length} 张图片",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final imageFile = data[index];
                      return ListTile(
                        title: Text(imageFile.path.split('/').last),
                        subtitle: Text(
                          '大小: ${(imageFile.lengthSync() / 1024).toStringAsFixed(2)} KB',
                        ),
                        leading: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: Image.file(imageFile, fit: BoxFit.contain),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  child: FilledButton.icon(
                    onPressed: () {
                      controller.saveImagesToLocal();
                    },
                    icon: Icon(Icons.save),
                    label: Text("导入"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
