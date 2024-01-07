import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:dartssh2/dartssh2.dart';
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
    getVideoPathList();
    super.onInit();
  }

  Future<SSHClient> initClient() async {
    return SSHClient(
        await SSHSocket.connect(sharedPreferences.getString('host') ?? "",
            int.parse(sharedPreferences.getString('port') ?? "")),
        username: sharedPreferences.getString('user') ?? "",
        onPasswordRequest: () => sharedPreferences.getString("pass"));
  }

  Future<SftpClient> initSftp() async {
    SSHClient sshClient = await initClient();
    return await sshClient.sftp();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getVideoPathList() async {
    final client = await initClient();
    final videoSSHPath = sharedPreferences.getString('video');
    final pathList = await client.run("ls $videoSSHPath -R");
    var pathString = utf8.decode(pathList).trim();
    List<String> lines = pathString.split("\n");
    videoPathList.value = [];
    for (String line in lines) {
      if (!line.contains("/")) {
        videoPathList.add("$videoSSHPath$line");
        videoNameList.add(line);
      }
    }
  }

  Future<File> getVideo(String filePath) async {
    try {
      final videoName = filePath.substring(filePath.lastIndexOf("/") + 1);
      final tmp = await getApplicationCacheDirectory();
      final tmpDirectory = Directory("${tmp.path}/video");
      if (!tmpDirectory.existsSync()) {
        tmpDirectory.create();
      }
      final tmpFile = File("${tmpDirectory.path}/$videoName");
      if (tmpFile.existsSync()) {
        return tmpFile;
      }
      final sftp = await initSftp();
      final file = await sftp.open(filePath);
      final content = await file.readBytes();
      tmpFile.writeAsBytesSync(content);
      update();
      return tmpFile;
    } catch (e) {
      print(e);
    }
    return File("");
  }

  Future<File> getVideoPreview(String filePath) async {
    await getVideo(filePath);
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
