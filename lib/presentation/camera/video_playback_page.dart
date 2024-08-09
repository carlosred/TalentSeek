import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_seek/data/providers/data_providers.dart';
import 'package:talent_seek/presentation/providers/presentation_providers.dart';
import 'package:video_player/video_player.dart';

class VideoPlayBackPage extends ConsumerStatefulWidget {
  const VideoPlayBackPage({super.key});

  @override
  ConsumerState<VideoPlayBackPage> createState() => _VideoPlayBackPageState();
}

class _VideoPlayBackPageState extends ConsumerState<VideoPlayBackPage> {
  late VideoPlayerController _videoController;
  @override
  void initState() {
    var videoRecorded = ref.read(recordedVideoProvider);
    _videoController = VideoPlayerController.file(videoRecorded!);
    initializeVideo();
    super.initState();
  }

  void initializeVideo() async {
    await _videoController.initialize();
    _videoController.setLooping(true);
    _videoController.play();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.1,
            child: Flexible(
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: Container(
                  color: Colors.black,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
