import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../Commons/commons.dart';

class CustomVideoPlayer extends StatefulWidget {
  final File file;

  const CustomVideoPlayer({Key? key, required this.file}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() async {
    videoPlayerController = VideoPlayerController.file(widget.file);
    await videoPlayerController.initialize();
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        looping: false,
        allowPlaybackSpeedChanging: true,
        cupertinoProgressColors: ChewieProgressColors(
          playedColor: AppColors.darkGrey,
          bufferedColor: Colors.red,
        ),
        hideControlsTimer: const Duration(seconds: 3));
    setState(() {});
    print("Video controller ${widget.file}");
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: chewieController != null
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Chewie(
                controller: chewieController!,
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
