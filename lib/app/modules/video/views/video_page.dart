import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wo_nas/app/modules/video/controllers/video_controller.dart';

class VideoPlayerPage extends StatefulWidget {
  final File videoFile;

  const VideoPlayerPage({super.key, required this.videoFile});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  VideoController controller = VideoController();

  @override
  void initState()  {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(widget.videoFile);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
         Center(
          child: Chewie(controller: _chewieController),


    ));
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
