import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'parse_image_folder_controller.dart';

class ParseImageFolderScreen extends GetView<ParseImageFolderController> {
  const ParseImageFolderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: "图片文件夹导入",
        onBack: () {
          Get.back();
        },
      ),
      body: controller.scanImageState.displaySuccess(
        loadingBuilder: () {
          return Center(
            child: TDLoading(
              size: TDLoadingSize.large,
              text: "正在扫描图片...",
            ),
          );
        },
        successBuilder: (data) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: TDTheme.of(context).brandNormalColor,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TDText(
                        "找到 ${data.length} 张图片",
                        font: TDTheme.of(context).fontBodyMedium,
                        textColor: TDTheme.of(context).fontGyColor1,
                      ),
                    ),
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
                      child: Image.file(
                        imageFile,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: TDButton(
                  text: "保存到本地",
                  width: double.infinity,
                  theme: TDButtonTheme.primary,
                  size: TDButtonSize.large,
                  onTap: () {
                    controller.saveImagesToLocal();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
