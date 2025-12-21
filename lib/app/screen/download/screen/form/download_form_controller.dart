import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/screen/parse/parse_controller.dart';
import 'package:tele_book/app/service/download_service.dart';
import 'package:tele_book/app/service/toast_service.dart';

class DownloadFormController extends GetxController {
  late final ParseResult parseResult;

  // 用于强制刷新图片的版本号，key 是图片索引
  final imageVersions = <int, RxInt>{}.obs;
  final titleController = TextEditingController();
  final downloadService = Get.find<DownloadService>();


  // 存储图片列表
  late final RxList<String> images;

  @override
  void onInit() {
    super.onInit();
    final parseResultStr = Get.arguments as String;
    parseResult = ParseResult.fromJson(jsonDecode(parseResultStr));
    debugPrint('DownloadFormController onInit: $parseResult');

    // 初始化图片列表
    images = RxList<String>.from(parseResult.images);

    // 初始化每张图片的版本号
    for (int i = 0; i < images.length; i++) {
      imageVersions[i] = 0.obs;
    }
    titleController.text = parseResult.title;
  }

  /// 刷新指定索引的图片
  void refreshImage(int index) {
    if (imageVersions.containsKey(index)) {
      imageVersions[index]!.value++;
    }
  }

  /// 移除指定索引的图片
  void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
      // 重新构建版本号映射
      final newVersions = <int, RxInt>{};
      for (int i = 0; i < images.length; i++) {
        if (i < index && imageVersions.containsKey(i)) {
          newVersions[i] = imageVersions[i]!;
        } else if (i >= index && imageVersions.containsKey(i + 1)) {
          newVersions[i] = imageVersions[i + 1]!;
        } else {
          newVersions[i] = 0.obs;
        }
      }
      imageVersions.value = newVersions;
    }
  }

  /// 重新排序图片
  void reorderImages(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // 移动图片
    final item = images.removeAt(oldIndex);
    images.insert(newIndex, item);

    // 移动版本号
    final oldVersion = imageVersions[oldIndex];
    final newVersions = <int, RxInt>{};

    for (int i = 0; i < images.length; i++) {
      if (i == newIndex) {
        // 新位置使用旧的版本号
        newVersions[i] = oldVersion ?? 0.obs;
      } else if (oldIndex < newIndex) {
        // 向后移动：oldIndex 到 newIndex 之间的元素前移
        if (i >= oldIndex && i < newIndex) {
          newVersions[i] = imageVersions[i + 1] ?? 0.obs;
        } else {
          newVersions[i] = imageVersions[i] ?? 0.obs;
        }
      } else {
        // 向前移动：newIndex 到 oldIndex 之间的元素后移
        if (i > newIndex && i <= oldIndex) {
          newVersions[i] = imageVersions[i - 1] ?? 0.obs;
        } else {
          newVersions[i] = imageVersions[i] ?? 0.obs;
        }
      }
    }

    imageVersions.value = newVersions;
  }

  void copyImageUrl(String url) {
    Clipboard.setData(ClipboardData(text: url));
    ToastService.showSuccess("图片链接已复制到剪贴板");
  }
}
