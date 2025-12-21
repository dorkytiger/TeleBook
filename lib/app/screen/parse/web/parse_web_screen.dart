import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/parse/web/parse_web_controller.dart';
import 'package:tele_book/app/widget/cross_platform_webview.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

class ParseWebScreen extends GetView<ParseWebController> {
  const ParseWebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: '解析网页',
        rightBarItems: [
          TDNavBarItem(
            icon: Icons.check,
            action: () {
              Get.offAndToNamed(
                "/download/form",
                arguments: jsonEncode(
                  ParseWebResult(
                    title: controller.title.value,
                    images: controller.images.toList(),
                  ).toJson(),
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            if (controller.selectBar.value == 0)
              Expanded(
                child: CrossPlatformWebView(controller: controller.webViewController),
              ),
            if (controller.selectBar.value == 1)
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemBuilder: (context, index) {
                      final item = controller.images[index];
                      return TDCell(
                        title: "图片 $index",
                        description: item,
                        leftIconWidget: CustomImageLoader(networkUrl: item),
                        onClick: (cell) {
                          TDActionSheet(
                            context,
                            visible: true,
                            onSelected: (actionItem, actionIndex) {
                              if (actionIndex == 0) {
                                controller.copyImageUrl(item);
                              }
                              if (actionIndex == 1) {
                                controller.saveImageTo(item);
                              }
                            },
                            items: [
                              TDActionSheetItem(label: "复制url"),
                              TDActionSheetItem(label: "保存到..."),
                            ],
                          );
                        },
                      );
                    },
                    itemCount: controller.images.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => TDBottomTabBar(
          TDBottomTabBarBasicType.iconText,
          useVerticalDivider: false,
          navigationTabs: [
            TDBottomTabBarTabConfig(
              tabText: "网页",
              selectedIcon: Icon(
                Icons.web,
                color: TDTheme.of(context).brandNormalColor,
              ),
              unselectedIcon: Icon(Icons.web_outlined),
              onTap: () {
                controller.selectBar.value = 0;
              },
            ),
            TDBottomTabBarTabConfig(
              tabText: "图片（${controller.images.length}）",
              selectedIcon: Icon(
                Icons.photo,
                color: TDTheme.of(context).brandNormalColor,
              ),
              unselectedIcon: Icon(Icons.photo_outlined),
              onTap: () {
                controller.selectBar.value = 1;
              },
            ),
          ],
        ),
      ),
    );
  }
}
