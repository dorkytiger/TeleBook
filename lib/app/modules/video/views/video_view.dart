import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wo_nas/app/modules/video/views/video_page.dart';

import '../controllers/video_controller.dart';

class VideoView extends GetView<VideoController> {
  const VideoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('视频'),
          centerTitle: true,
        ),
        body: Obx(() => RefreshIndicator(
              onRefresh: () async {
                await controller.getVideoPathList();
              },
              child: ListView.builder(
                itemCount: controller.videoPathList.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                      height: 200,
                      child: GestureDetector(
                        onTap: () async {
                          File video = await controller
                              .getVideo(controller.videoPathList[index]);
                          Get.to(VideoPlayerPage(videoFile: video));
                        },
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(controller.videoNameList[index]),
                            ),
                            Expanded(
                                flex: 1,
                                child: FutureBuilder<File>(
                                  future: controller.getVideo(
                                      controller.videoPathList[index]),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<File> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return const Center(child: Text("加载失败"));
                                    } else if (snapshot.hasData) {
                                      return Container(
                                        height: 100,
                                        child: VideoPlayerPage(
                                          videoFile: snapshot.data!,
                                        ),
                                      );
                                    } else {
                                      return const Center(child: Text("空白页"));
                                    }
                                  },
                                ))
                          ],
                        ),
                      ));
                },
              ),
            )));
  }
}
