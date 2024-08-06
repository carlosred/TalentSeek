import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:talent_seek/presentation/widgets/challenge_item.dart';
import 'package:talent_seek/presentation/widgets/expandable_video_info.dart';

import 'package:video_player/video_player.dart';

import '../../domain/video/video.dart';

class VideoReelWidget extends ConsumerStatefulWidget {
  const VideoReelWidget({
    required this.index,
    required this.video,
    required this.videoPlayerController,
    super.key,
  });

  final VideoPlayerController videoPlayerController;
  final int index;
  final Video? video;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VideoReelWidgetState();
}

class _VideoReelWidgetState extends ConsumerState<VideoReelWidget>
    with SingleTickerProviderStateMixin {
  var percentageOfVideo = 0.0;

  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    var totalVideoDuration = widget.videoPlayerController.value.duration;
    _controller =
        AnimationController(vsync: this, duration: totalVideoDuration);
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    widget.videoPlayerController.play();

    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.videoPlayerController.addListener(() async {
        if (widget.videoPlayerController.value.isCompleted) {
          widget.videoPlayerController.seekTo(Duration.zero);
          widget.videoPlayerController.play();
          _controller.reset();
          await Future.delayed(const Duration(milliseconds: 15));
          _controller.forward();
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    widget.videoPlayerController.pause();
    widget.videoPlayerController.seekTo(Duration.zero);
    _controller.reset();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (widget.videoPlayerController.value.isPlaying) {
            widget.videoPlayerController.pause();
            _controller.stop();
          } else {
            widget.videoPlayerController.play();
            _controller.forward();
          }
        },
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(children: [
            VideoPlayer(widget.videoPlayerController),
            Positioned(
              bottom: 20.0,
              left: 5.0,
              right: 5.0,
              child: SizedBox(
                height: 20,
                width: size.width,
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1.0,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) => FractionallySizedBox(
                        widthFactor: _animation.value,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 50.0,
              left: 5.0,
              right: 5.0,
              child: ExpandableVideoInfo(
                videoInfo: widget.video,
              ),
            ),
            if (widget.video?.objectChallenge != null &&
                widget.video?.roleSeeked != null)
              ChallengeItem(
                roleSeeked: widget.video!.roleSeeked!,
              ),
          ]),
        ),
      ),
    );
  }
}
