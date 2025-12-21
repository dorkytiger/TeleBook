import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/download/screen/form/download_form_controller.dart';
import 'package:tele_book/app/service/navigator_service.dart';
import 'package:tele_book/app/service/toast_service.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

class DownloadFormScreen extends GetView<DownloadFormController> {
  const DownloadFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: '申请下载表单',
        onBack: () {
          Get.back();
        },
        rightBarItems: [
          TDNavBarItem(
            icon: Icons.check,
            action: () async {
              final downloadService = controller.downloadService;
              ToastService.showLoading();
              await downloadService.downloadBatch(
                urls: controller.images,
                groupName: controller.titleController.text,
              );
              ToastService.dismiss();
              Get.offAndToNamed('/download');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TDInput(
            leftLabel: "标题",
            controller: controller.titleController,
            hintText: "请输入下载标题",
          ),
          Obx(
            () => TDCell(
              title: "下载图片确认",
              description: "共 ${controller.images.length} 张图片，长按可排序，点击可操作",
            ),
          ),
          Expanded(child: _buildImageList(context)),
        ],
      ),
    );
  }

  Widget _buildImageList(BuildContext context) {
    return Obx(() {
      final imageCount = controller.images.length;
      return ReorderableListView.builder(
        itemBuilder: (context, index) {
          return _buildImageCell(index);
        },
        itemCount: imageCount,
        onReorder: (oldIndex, newIndex) {
          controller.reorderImages(oldIndex, newIndex);
        },
        proxyDecorator: (child, index, animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final double animValue = Curves.easeInOut.transform(
                animation.value,
              );
              final double elevation = lerpDouble(0, 6, animValue)!;
              final double scale = lerpDouble(1, 1.02, animValue)!;
              return Transform.scale(
                scale: scale,
                child: Material(
                  elevation: elevation,
                  color: Colors.transparent,
                  shadowColor: Colors.black26,
                  child: child,
                ),
              );
            },
            child: child,
          );
        },
      );
    });
  }

  Widget _buildImageCell(int index) {
    final item = controller.images[index];

    // 使用 KeyedSubtree 添加 key，ReorderableListView 必需
    return KeyedSubtree(
      key: ValueKey('$item-$index'),
      child: TDCell(
        title: '图片 ${index + 1}',
        leftIconWidget: SizedBox(
          height: 100,
          width: 80,
          child: CustomImageLoader(networkUrl: item),
        ),
        description: item,
        onClick: (TDCell cell) {
          TDActionSheet(
            NavigatorService.currentContext(),
            visible: true,
            onSelected: (actionItem, actionIndex) {
              if (actionIndex == 0) {
                controller.refreshImage(index);
              }
              if (actionIndex == 1) {
                controller.copyImageUrl(item);
              }
              if (actionIndex == 2) {
                controller.removeImage(index);
              }
            },
            items: [
              TDActionSheetItem(label: '刷新图片'),
              TDActionSheetItem(label: '复制url'),
              TDActionSheetItem(label: '移除'),
            ],
          );
        },
      ),
    );
  }
}
