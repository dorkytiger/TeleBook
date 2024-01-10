import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoController extends GetxController {
  RxList<String> videoPathList = <String>[].obs;
  RxList<String> videoNameList = <String>[].obs;

  final pageSize = 6;

  late SharedPreferences sharedPreferences;
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("video") != null) {
      getVideoPathList(sharedPreferences.getString("video")!);
    }

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getVideoPathList(String path) async {
    try {
      Directory videoDirectory = Directory(path);
      if (!videoDirectory.existsSync()) {
        return;
      }
      List<FileSystemEntity> videoList = videoDirectory.listSync();
      if (videoList.isEmpty) {
        return;
      }
      for (FileSystemEntity video in videoList) {
        if (video.path.endsWith(".mp4")) {
          videoPathList.add(video.path);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<File> getVideoPreview(String filePath) async {
    try {
      final videoName = filePath.substring(filePath.lastIndexOf("/") + 1);
      final tmp = await getApplicationCacheDirectory();
      final tmpFilePath = "${tmp.path}/video/$videoName";
      final tmpPreview = Directory("${tmp.path}/videoPreview");
      if (!tmpPreview.existsSync()) {
        tmpPreview.createSync();
      }
      final thumbnailPath =
          "${tmpPreview.path}/${videoName.replaceAll(".mp4", "")}.jpg";
      print(thumbnailPath);
      if (File(thumbnailPath).existsSync()) {
        return File(thumbnailPath);
      }
      final fileName = await VideoThumbnail.thumbnailFile(
          video: tmpFilePath,
          thumbnailPath: thumbnailPath,
          imageFormat: ImageFormat.JPEG,
          maxHeight: 128,
          quality: 25);
      print(fileName);
      print(thumbnailPath);
      return File(thumbnailPath);
    } catch (e) {
      print(e);
    }
    return File("");
  }
}
