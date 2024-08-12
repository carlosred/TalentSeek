// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:talent_seek/presentation/controllers/discover/discover_page_controller.dart';
import 'package:talent_seek/presentation/providers/presentation_providers.dart';
import 'package:talent_seek/presentation/widgets/challenge_item.dart';
import 'package:talent_seek/presentation/widgets/expandable_video_info.dart';
import 'package:talent_seek/utils/styles.dart';

import 'package:video_player/video_player.dart';

import '../../domain/video/video.dart';
import 'placeholders.dart';

class VideoReelWidget extends ConsumerStatefulWidget {
  const VideoReelWidget({
    required this.index,
    required this.video,
    required this.videoPlayerController,
    super.key,
  });

  final VideoPlayerController? videoPlayerController;
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
  late VideoPlayerController _videoPlayerController;
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.videoPlayerController!.addListener(() async {
        if (_videoPlayerController.value.isCompleted) {
          setState(() {
            _videoPlayerController.seekTo(Duration.zero);
            _videoPlayerController.play();
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
    if (_isControllerDisposed() == true) {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.video!.videoUrl ?? ''),
      );
      _videoPlayerController.initialize();

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _videoPlayerController.addListener(() async {
          if (_videoPlayerController.value.isInitialized == true) {
            totalVideoDurationInSeconds =
                _videoPlayerController.value.duration.inSeconds;
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
            _videoPlayerController.play();

            _controller.forward();
            setState(() {});
          }

          if (_videoPlayerController.value.isCompleted) {
            setState(() {
              _videoPlayerController.seekTo(Duration.zero);
              _videoPlayerController.play();
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
    } else {
      _videoPlayerController = widget.videoPlayerController!;
      totalVideoDurationInSeconds =
          _videoPlayerController.value.duration.inSeconds;
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
      _videoPlayerController.play();

      _controller.forward();
    }

    super.initState();
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
        _videoPlayerController
            .seekTo(Duration(seconds: totalVideoDurationInSeconds));
        _controller.reset();
        _controller.forward();
      });
    } else {
      setState(() {
        _controller.duration = Duration(
          seconds: totalVideoDurationInSeconds - videoPosition,
        );
        _videoPlayerController.seekTo(Duration(seconds: videoPosition));

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

  bool _isControllerDisposed() {
    var videoControllerList = ref.read(discoverPageControllerProvider);
    return videoControllerList.value![widget.index] == null;
  }

  Widget _videoShimmer() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.grey,
        loop: 3,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ContentPlaceholder(
              lineType: ContentLineType.threeLines,
            ),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.pause();
    _videoPlayerController.seekTo(Duration.zero);
    _videoPlayerController.dispose();
    _controller.reset();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    ref.listen(currentVideoIndex, (previous, next) {
      ref
          .read(discoverPageControllerProvider.notifier)
          .deleteVideoControllerDisposed(index: previous!);
    });
    return (_videoPlayerController.value.isInitialized)
        ? Scaffold(
            body: SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(children: [
                GestureDetector(
                  onTap: () {
                    if (_videoPlayerController.value.isPlaying) {
                      _videoPlayerController.pause();
                      _controller.stop();
                    } else {
                      _videoPlayerController.play();
                      _controller.forward();
                    }
                  },
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: SizedBox(
                        width: (_videoPlayerController.value.size.width),
                        height: _videoPlayerController.value.size.height,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                    ),
                  ),
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
                            _updatePositionOfVideo(
                                details: details, size: size);
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
                            _updatePositionOfVideo(
                                details: details, size: size);
                          },
                          onTapDown: (details) {
                            _updatePositionOfVideo(
                                details: details, size: size);
                          },
                          child: FractionallySizedBox(
                            widthFactor: _progress,
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Styles.backgroundColor,
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
          )
        : _videoShimmer();
  }
}
