import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/book/screen/edit/book_edit_screen.dart';
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
      appBar: AppBar(
        title: Text("解析网页"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.webViewController.reload();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: ValueListenableBuilder<int>(
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
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showParseImageList(context);
        },
        label: Text("解析结果 ${controller.images.length}"),
        icon: Icon(Icons.book),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: CrossPlatformWebView(
                controller: controller.webViewController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showParseImageList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Scaffold(
              appBar: AppBar(
                title: Text("解析到 ${controller.images.length} 张图片"),
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.images.length,
                        itemBuilder: (context, index) {
                          final image = controller.images[index];
                          return ListTile(
                            leading: CachedNetworkImage(
                              imageUrl: image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            title: Text(image),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    value: 'copy',
                                    child: Row(
                                      children: [
                                        Icon(Icons.copy, size: 16),
                                        SizedBox(width: 8),
                                        Text('复制链接'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'download',
                                    child: Row(
                                      children: [
                                        Icon(Icons.download, size: 16),
                                        SizedBox(width: 8),
                                        Text('下载图片'),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                              onSelected: (value) {
                                if (value == 'copy') {
                                  Clipboard.setData(ClipboardData(text: image));
                                } else if (value == 'download') {
                                  controller.saveImageTo(image);
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              bottomSheet: Container(
                padding: EdgeInsets.all(16),
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    controller.downloadService.downloadBatch(
                      urls: controller.images,
                      groupName: controller.title.value,
                    );
                    Get.back();
                  },
                  label: Text("下载"),
                  icon: Icon(Icons.download),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
