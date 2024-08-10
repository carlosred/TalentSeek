import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:talent_seek/presentation/providers/presentation_providers.dart';
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
  int videoPosition = 0;
  var _progress = 0.0;
  int totalVideoDurationInSeconds = 0;

  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    totalVideoDurationInSeconds =
        widget.videoPlayerController.value.duration.inSeconds;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: totalVideoDurationInSeconds,
      ),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _animation.addListener(() {
      if (mounted) {
        setState(() {
          _progress = _animation.value;
        });
      }
    });
    widget.videoPlayerController.play();

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.videoPlayerController.addListener(() async {
        if (widget.videoPlayerController.value.isCompleted) {
          setState(() {
            widget.videoPlayerController.seekTo(Duration.zero);
            widget.videoPlayerController.play();
            _controller.duration = Duration(
              seconds: totalVideoDurationInSeconds,
            );
            _animation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: _controller,
              curve: Curves.easeInOut,
            ));
            _controller.reset();
            _controller.forward();
          });
        }
      });
    });

    super.initState();
  }

  void _checkControllers({required int currentIndex}) {
    if (currentIndex == widget.index) {
      if (!widget.videoPlayerController.value.isPlaying &&
          !_controller.isAnimating) {
        widget.videoPlayerController.play();
        _controller.forward();
      }
    } else {
      widget.videoPlayerController.pause();
      widget.videoPlayerController.seekTo(Duration.zero);
      _controller.reset();
    }
  }

  void _updatePositionOfVideo({
    required Size size,
    required dynamic details,
  }) {
    final globalPosition = details.globalPosition;

    RenderBox renderBox = context.findRenderObject() as RenderBox;

    final localPosition = renderBox.globalToLocal(globalPosition);

    localPosition.dx;

    _progress = (localPosition.dx / (size.width - 10));

    videoPosition = (totalVideoDurationInSeconds * _progress).toInt();

    if (_progress > 1.0) {
      setState(() {
        _progress = 1.0;
        widget.videoPlayerController
            .seekTo(Duration(seconds: totalVideoDurationInSeconds));
        _controller.reset();
        _controller.forward();
      });
    } else {
      setState(() {
        _controller.duration = Duration(
          seconds: totalVideoDurationInSeconds - videoPosition,
        );
        widget.videoPlayerController.seekTo(Duration(seconds: videoPosition));

        _animation = Tween<double>(
          begin: _progress,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.linear,
          ),
        );

        _controller.reset();
        _controller.forward();
      });
    }
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
    ref.listen(currentVideoIndex, (previous, next) {
      _checkControllers(currentIndex: next);
    });
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(children: [
          GestureDetector(
            onTap: () {
              if (widget.videoPlayerController.value.isPlaying) {
                widget.videoPlayerController.pause();
                _controller.stop();
              } else {
                widget.videoPlayerController.play();
                _controller.forward();
              }
            },
            child: VideoPlayer(widget.videoPlayerController),
          ),
          Positioned(
            bottom: 20.0,
            left: 5.0,
            right: 5.0,
            child: SizedBox(
              height: 20,
              width: size.width,
              child: Stack(
                children: [
                  GestureDetector(
                    onTapDown: (details) {
                      _updatePositionOfVideo(details: details, size: size);
                    },
                    child: FractionallySizedBox(
                      widthFactor: 1.0,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onPanUpdate: (details) {
                      _updatePositionOfVideo(details: details, size: size);
                    },
                    onTapDown: (details) {
                      _updatePositionOfVideo(details: details, size: size);
                    },
                    child: FractionallySizedBox(
                      widthFactor: _progress,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  ),
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
          if (widget.video?.roleSeeked != null &&
              widget.video!.roleSeeked!.isNotEmpty)
            ChallengeItem(
              roleSeeked: widget.video!.roleSeeked!,
            ),
        ]),
      ),
    );
  }
}
