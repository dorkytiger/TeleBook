import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/screen/parse/web/parse_web_controller.dart';
import 'package:tele_book/app/screen/task/task_controller.dart';
import 'package:tele_book/app/widget/cross_platform_webview.dart';

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
          child: Obx(
            () => LinearProgressIndicator(
              value: (controller.parseProgress.value / 100).toDouble(),
            ),
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton.extended(
          onPressed: () {
            _showParseImageList(context);
          },
          label: Text("解析结果 ${controller.images.length}"),
          icon: Icon(Icons.book),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: CrossPlatformWebView(
              controller: controller.webViewController,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showParseImageList(BuildContext context) async {
    final callBack = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Obx(
              () => Scaffold(
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
                                    Clipboard.setData(
                                      ClipboardData(text: image),
                                    );
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
                      Get.back(
                        result: () {
                          controller.downloadService.downloadBatch(
                            urls: controller.images,
                            groupName: controller.title.value,
                          );
                          Get.back();
                          final taskController = Get.find<TaskController>();
                          taskController.tabController.animateTo(0);
                        },
                      );
                    },
                    label: Text("下载"),
                    icon: Icon(Icons.download),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    callBack.call();
  }
}
