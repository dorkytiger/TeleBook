import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wo_nas/app/view/download/widget/download_card_widget.dart';
import 'package:wo_nas/app/view/download/widget/download_floating_button_widget.dart';

import '../controllers/download_controller.dart';

class DownloadView extends GetView<DownloadController> {
  const DownloadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: const Text('下载'),
            centerTitle: true,
          ),
          body: controller.downloadStates.isNotEmpty
              ? Obx(() => ListView.builder(
                  itemCount: controller.downloadStates.length,
                  itemBuilder: (context, index) {
                    return Obx(() => downloadCardWidget(
                          controller.downloadStates[index].page,
                          controller.downloadStates[index].pageSize,
                          controller.downloadStates[index].progress,
                          controller.downloadStates[index].proImg,
                          controller.downloadStates[index].preview,
                          controller.downloadStates[index].state,
                          () {
                            controller.downloadBook(
                                index, controller.downloadStates[index].link);
                          },
                          () {
                            controller.deleteDown(index);
                          },
                        ));
                  }))
              : const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "暂无下载链接，点击右下角",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.black54,
                      ),
                      Text(
                        "添加",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      )
                    ],
                  ),
                ),
          floatingActionButton: DownloadFloatingButtonWidget(
              urlController: controller.urlController,
              onConfirm: () {
                controller.downloadBook(controller.downloadStates.length,
                    controller.urlController.text);
              }),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          // 调整悬浮按钮位置
        ));
  }
}
