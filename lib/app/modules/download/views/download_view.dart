import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:wo_nas/app/modules/download/views/download_progress.dart';

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
          body: controller.currentDownLink.isNotEmpty
              ? Obx(() => ListView.builder(
                  itemCount: controller.currentDownLink.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(5, 4, 5, 4),
                      child: Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                  height: 150,
                                  child: Obx(
                                    () => (controller.currentDownPage.length >
                                                index
                                            ? (controller
                                                    .currentDownPage[index] >
                                                1)
                                            : false)
                                        ? Image.file(File(controller
                                            .currentDownPreview[index]))
                                        : Obx(() => (controller
                                                    .connectState[index] ==
                                                1
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : const Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.cancel_outlined,
                                                    size: 30,
                                                    color: Colors.grey,
                                                  ),
                                                  Text("请求失败"),
                                                ],
                                              ))),
                                  ))),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(
                                      () => Text(
                                        "当前下载页数：${controller.currentDownPage.length > index ? controller.currentDownPage[index] : 0}/${controller.currentDownPageSize.length > index ? controller.currentDownPageSize[index] : 0}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                          iconSize: 30,
                                          onPressed: () {
                                            controller.getBook(
                                                index,
                                                controller
                                                    .currentDownLink[index]);
                                          },
                                          icon: const Icon(
                                            Icons.refresh,
                                            color: Colors.blue,
                                          )),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                          iconSize: 30,
                                          onPressed: () {
                                            controller.deleteDown(index);
                                          },
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.blue,
                                          )),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text("总进度"),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                      child: Obx(() => controller
                                                  .currentDownProgress
                                                  .isNotEmpty &&
                                              controller.currentDownProgress
                                                      .length >
                                                  index
                                          ? LinearProgressIndicator(
                                              color: Colors.blue,
                                              value: controller
                                                  .currentDownProgress[index],
                                            )
                                          : const LinearProgressIndicator(
                                              value: 0,
                                            )),
                                    ),
                                    const Text("当前页进度"),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 5, 0),
                                      child: Obx(() =>
                                          controller.currentDownProImg.length >
                                                      index &&
                                                  controller.currentDownProImg[
                                                          index] >=
                                                      0.0
                                              ? LinearProgressIndicator(
                                                  color: Colors.blue,
                                                  value: controller
                                                      .currentDownProImg[index],
                                                )
                                              : const LinearProgressIndicator(
                                                  value: 0,
                                                )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text(
                        '请输入链接',
                        style: TextStyle(color: Colors.black54),
                      ),
                      content: SizedBox(
                        child: TextField(
                            controller: controller.urlController,
                            keyboardType: TextInputType.multiline,
                            autofocus: true,
                            textInputAction: TextInputAction.done,
                            maxLines: 5,
                            minLines: 1,
                            decoration: const InputDecoration(
                              hintText: '输入',
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              isDense: true,
                            )),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            '取消',
                            style: TextStyle(color: Colors.black54),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text(
                            '确定',
                            style: TextStyle(color: Colors.black54),
                          ),
                          onPressed: () {
                            final index = controller.currentDownLink.length;
                            controller.getBook(
                                index, controller.urlController.text);
                            Navigator.of(context).pop(); // 关闭对话框并返回输入的文本
                          },
                        ),
                      ],
                    );
                  });
            },
            tooltip: 'Increment',
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          // 调整悬浮按钮位置
        ));
  }
}
