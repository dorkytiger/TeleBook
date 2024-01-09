import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/download_controller.dart';

class DownloadView extends GetView<DownloadController> {
  const DownloadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              controller.getBook();
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
                return Row(
                  children: [
                    CircularProgressIndicator(
                      value: controller.currentDownLoadProgress[index],
                    ),
                    Text(
                      controller.currentDownLink[index],
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                );
              })
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "暂无下载链接",
                    style: TextStyle(fontSize: 16,color: Colors.blue),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.download_for_offline),
                            Text("点击下载",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.blue))
                          ],
                        )),
                  ),
                )
              ],
            ),
    );
  }
}
