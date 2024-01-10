import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wo_nas/app/modules/video/views/video_play.dart';

import '../controllers/video_controller.dart';

class VideoView extends GetView<VideoController> {
  const VideoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '视频',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: ListView.builder(
          itemCount: controller.videoPathList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () async {
                  Get.to(VideoPlay(videoPath: controller.videoPathList[index]));
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
                )
            );
          },
        ));
  }
}
