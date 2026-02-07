import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/parse/web/parse_web_controller.dart';
import 'package:tele_book/app/service/toast_service.dart';
import 'package:tele_book/app/widget/cross_platform_webview.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';
import 'package:tele_book/app/widget/td/td_action_sheet_item_icon_widget.dart';

class ParseWebScreen extends GetView<ParseWebController> {
  const ParseWebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: '解析网页',
        rightBarItems: [
          TDNavBarItem(
            icon: Icons.refresh,
            action: () {
              controller.webViewController.reload();
            },
          ),
          TDNavBarItem(
            icon: Icons.cleaning_services,
            action: () async {
              try {
                await controller.webViewController.clearCache();
                if (Platform.isWindows) {
                  ToastService.showSuccess('已重新加载页面（Windows 平台不支持清除缓存）');
                } else {
                  ToastService.showSuccess('缓存已清除');
                }
              } catch (e) {
                ToastService.showError('清除缓存失败: $e');
              }
            },
          ),
          TDNavBarItem(
            icon: Icons.check,
            action: () {
              Get.toNamed(
                AppRoute.downloadForm,
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
                child: Column(
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable:
                          controller.webViewController.loadingProgressNotifier,
                      builder: (context, progress, child) {
                        if (progress > 0 && progress < 100) {
                          return TDCell(
                            title: "解析中... $progress%",
                            descriptionWidget: TDProgress(
                              type: TDProgressType.linear,
                              value: progress / 100,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    Expanded(
                      child: CrossPlatformWebView(
                        controller: controller.webViewController,
                      ),
                    ),
                  ],
                ),
              ),
            if (controller.selectBar.value == 1)
              Expanded(
                child: Column(
                  children: [
                    TDNoticeBar(
                      content: "多图片页面可能需要上下滑动加载全部图片后才能完整解析，点击图片可进行操作",
                      marquee: true,
                      prefixIcon: Icons.info,
                    ),
                    Expanded(
                      child: Obx(
                        () => ListView.builder(
                          itemBuilder: (context, index) {
                            final item = controller.images[index];
                            return TDCell(
                              title: "图片 $index",
                              description: item,
                              leftIconWidget: CustomImageLoader(
                                networkUrl: item,
                              ),
                              disabled: true,
                              noteWidget: TDButton(
                                icon: Icons.more_horiz,
                                size: TDButtonSize.small,
                                theme: TDButtonTheme.primary,
                                type: TDButtonType.text,
                                onTap: () {
                                  TDActionSheet.showGroupActionSheet(
                                    context,

                                    onSelected: (actionItem, actionIndex) {
                                      if (actionIndex == 0) {
                                        controller.copyImageUrl(item);
                                      }
                                      if (actionIndex == 1) {
                                        controller.saveImageTo(item);
                                      }
                                    },
                                    items: [
                                      TDActionSheetItem(
                                        label: "复制url",
                                        icon: TDActionSheetItemIconWidget(
                                          iconData: Icons.copy,
                                        ),
                                        group: "操作",
                                      ),
                                      TDActionSheetItem(
                                        label: "保存到...",
                                        icon: TDActionSheetItemIconWidget(
                                          iconData: Icons.save_alt,
                                        ),
                                        group: "操作",
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                          itemCount: controller.images.length,
                        ),
                      ),
                    ),
                  ],
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
              unselectedIcon: Icon(
                Icons.web_outlined,
                color: TDTheme.of(context).grayColor12,
              ),
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
              unselectedIcon: Icon(
                Icons.photo_outlined,
                color: TDTheme.of(context).grayColor12,
              ),
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
