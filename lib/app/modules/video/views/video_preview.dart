import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wo_nas/app/modules/video/controllers/video_controller.dart';

class VideoPreview extends StatefulWidget {
  final File videoFile;

  const VideoPreview({super.key, required this.videoFile});

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _videoPlayerController;
  VideoController controller = VideoController();

  @override
  void initState()  {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(widget.videoFile);
    _videoPlayerController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
         Center(
          child: VideoPlayer(_videoPlayerController),


    ));
  }
  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}
