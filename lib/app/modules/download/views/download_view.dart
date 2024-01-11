import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
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
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              '请输入链接',
                              style: TextStyle(color: Colors.blue),
                            ),
                            content: TextField(
                              controller: controller.urlController,
                              keyboardType: TextInputType.text,
                              autofocus: true,
                              textInputAction: TextInputAction.done,
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('取消'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('确定'),
                                onPressed: () {
                                  controller.getBook(
                                      controller.currentDownLink.length);
                                  Navigator.of(context).pop(); // 关闭对话框并返回输入的文本
                                },
                              ),
                            ],
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ))
            ],
          ),
          body: controller.currentDownLink.isNotEmpty
              ? ListView.builder(
                  itemCount: controller.currentDownLink.length,
                  itemBuilder: (context, index) {
                    return Obx(
                      () => controller.currentDownProgress[index] != 1.0
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(5, 4, 5, 4),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: FutureBuilder(
                                    future: controller.getDownPreview(index),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      if (snapshot.error != null) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                        // 当数据正在加载时显示进度指示器
                                      } else if (snapshot.hasError) {
                                        return Text(
                                            'Error: ${snapshot.error}'); // 如果发生错误，显示错误信息
                                      } else {
                                        return SizedBox(
                                          height: 150,
                                          child: Image.file(
                                            File(snapshot.data),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ); // 当数据加载完成，显示数据
                                      }
                                    },
                                  )),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "当前下载页数：${controller.currentDownPage[index]}/${controller.currentDownPageSize[index]}",
                                              style: const TextStyle(fontSize: 18),
                                            ),

                                             IconButton(
                                               iconSize: 35,
                                                 onPressed: () {},
                                                 icon: const Icon(
                                                   Icons.cancel,
                                                   color: Colors.blue,
                                                 )),

                                          ],
                                        ),
                                        const Text("总进度"),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 5, 5),
                                          child: LinearProgressIndicator(
                                            color: Colors.blue,
                                            value: controller
                                                .currentDownProgress[index],
                                          ),
                                        ),
                                        const Text("当前页"),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 5, 0),
                                          child: LinearProgressIndicator(
                                            color: Colors.blue,
                                            value: controller
                                                .currentDownProImg[index],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ))
                          : Container(
                              child: null,
                            ),
                    );
                  })
              : const Center(
                  child: Text(
                    "暂无下载链接",
                    style: TextStyle(fontSize: 18),
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
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text(
                            '确定',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            controller
                                .getBook(controller.currentDownLink.length);
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
