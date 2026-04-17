import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/screen/parse/web/parse_web_controller.dart';
import 'package:tele_book/app/store/download_store.dart';
import 'package:tele_book/app/widget/cross_platform_webview.dart';
import 'package:tele_book/app/widget/custom_empty.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

class ParseWebScreen extends StatelessWidget {
  final String parseUrl;

  const ParseWebScreen({super.key, required this.parseUrl});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParseWebController(parseUrl: parseUrl),
      child: _ParseWebContent(),
    );
  }
}

class _ParseWebContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ParseWebController>(
      builder: (context, controller, child) {
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
              child: LinearProgressIndicator(
                value: (controller.parseProgress / 100).toDouble(),
              ),
            ),
          ),
          floatingActionButton: controller.images.isEmpty
              ? SizedBox.shrink()
              : FloatingActionButton(
                  onPressed: () {
                    _showParseImageList(context, controller);
                  },
                  child: Badge.count(
                    count: controller.images.length,
                    child: Icon(Icons.download),
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
      },
    );
  }

  Future<void> _showParseImageList(
    BuildContext context,
    ParseWebController controller,
  ) async {
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
            return Scaffold(
              appBar: AppBar(
                title: Text("解析到 ${controller.images.length} 张图片"),
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      // 读取 DownloadService
                      final downloadService = context.read<DownloadStore>();

                      // 开始批量下载
                      await downloadService.downloadBatch(
                        urls: controller.images,
                        groupName: controller.title,
                      );

                      // 关闭当前 bottom sheet
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }

                      // 关闭 ParseWebScreen
                      if (context.mounted) {
                        context.pop();
                      }

                      // 导航到首页的任务 tab，并显示下载子 tab
                      // tab=1 表示任务页面，taskTab=0 表示下载 tab
                      if (context.mounted) {
                        context.go('/home?tab=1&taskTab=0');
                      }
                    },
                    icon: const Icon(Icons.check),
                  ),
                ],
              ),
              body: controller.images.isEmpty
                  ? Center(child: CustomEmpty(message: '暂无图片'))
                  : Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        spacing: 16,
                        children: [
                          Expanded(
                            child: ListView.separated(
                              itemCount: controller.images.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final image = controller.images[index];
                                return Row(
                                  children: [
                                    CustomImageLoader(networkUrl: image),
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                          image,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    MenuAnchor(
                                      menuChildren: [
                                        MenuItemButton(
                                          leadingIcon: const Icon(
                                            Icons.copy,
                                            size: 16,
                                          ),
                                          onPressed: () {
                                            Clipboard.setData(
                                              ClipboardData(text: image),
                                            );
                                          },
                                          child: const Text('复制链接'),
                                        ),
                                        MenuItemButton(
                                          leadingIcon: const Icon(
                                            Icons.download,
                                            size: 16,
                                          ),
                                          onPressed: () {
                                            controller.saveImageTo(image);
                                          },
                                          child: const Text('下载图片'),
                                        ),
                                      ],
                                      builder:
                                          (btnContext, menuController, child) =>
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.more_vert,
                                                ),
                                                onPressed: () =>
                                                    menuController.isOpen
                                                    ? menuController.close()
                                                    : menuController.open(),
                                              ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
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
