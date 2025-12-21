import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/parse/parse_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ParseScreen extends GetView<ParseController> {
  const ParseScreen({super.key});

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
                  ParseResult(
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
                child: WebViewWidget(controller: controller.webViewController),
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
                        leftIconWidget: SizedBox(
                          height: 100,
                          width: 80,
                          child: Image.network(
                            item,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.broken_image,
                                size: 50,
                                color: TDTheme.of(context).grayColor4,
                              );
                            },
                          ),
                        ),
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
