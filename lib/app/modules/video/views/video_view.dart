import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wo_nas/app/modules/video/views/video_play.dart';

import '../controllers/video_controller.dart';

class VideoView extends GetView<VideoController> {
  const VideoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: AppBar(
          title: const Text(
            '视频',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: controller.videoPathList.isNotEmpty
            ? ListView.builder(
                itemCount: controller.videoPathList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () async {
                        Get.to(VideoPlay(
                            videoPath: controller.videoPathList[index]));
                      },
                      child: SizedBox(
                        height: 150,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: FutureBuilder(
                                  future: controller.getVideoPreview(
                                      controller.videoPathList[index]),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return const Center(child: Text("加载失败"));
                                    } else if (snapshot.hasData) {
                                      return Image.file(snapshot.data!);
                                    } else {
                                      return const Center(child: Text("空白页"));
                                    }
                                  },
                                )),
                            Expanded(
                              flex: 2,
                              child: Text(controller.videoNameList[index]),
                            ),
                          ],
                        ),
                      ));
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "暂无视频",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 150,
                    child:  TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: const Text(
                                    '请输入路径',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  content: SizedBox(
                                    child: TextField(
                                        controller:
                                        controller.videoPathController,
                                        keyboardType: TextInputType.multiline,
                                        autofocus: true,
                                        textInputAction: TextInputAction.done,
                                        maxLines: 5,
                                        minLines: 1,
                                        decoration: const InputDecoration(
                                          hintStyle:
                                          TextStyle(color: Colors.grey),
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
                                        controller.sharedPreferences.setString(
                                            "video",
                                            controller.videoPathController.text);
                                        Navigator.of(context)
                                            .pop(); // 关闭对话框并返回输入的文本
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "点击添加",
                              style: TextStyle(color: Colors.blue, fontSize: 18,fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    )
                  )
                ],
              )));
  }
}
