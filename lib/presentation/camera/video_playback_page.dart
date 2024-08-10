import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:talent_seek/presentation/controllers/camera/video_playback_page_controller.dart';
import 'package:talent_seek/presentation/providers/presentation_providers.dart';
import 'package:talent_seek/presentation/widgets/upload_video_button.dart';
import 'package:talent_seek/utils/enum.dart';
import 'package:video_player/video_player.dart';

import '../../utils/constants.dart';
import '../../utils/styles.dart';

class VideoPlayBackPage extends ConsumerStatefulWidget {
  const VideoPlayBackPage({super.key});

  @override
  ConsumerState<VideoPlayBackPage> createState() => _VideoPlayBackPageState();
}

class _VideoPlayBackPageState extends ConsumerState<VideoPlayBackPage> {
  late VideoPlayerController _videoController;
  late CameraController controller;
  @override
  void initState() {
    var videoRecorded = ref.read(recordedVideoProvider);
    _videoController = VideoPlayerController.file(videoRecorded!);
    initializeVideo();
    super.initState();
  }

  void initializeVideo() async {
    controller = ref.read(cameraControllerProvider).getCameraController;
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
    const double previewAspectRatio = 0.7;
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    var videoPlaybackPageController =
        ref.watch(videoPlayBackPageControllerProvider);
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: AspectRatio(
                  aspectRatio: 1 / previewAspectRatio,
                  child: ClipRect(
                    child: Transform.scale(
                      scale: controller.value.aspectRatio / previewAspectRatio,
                      child: Center(
                        child: VideoPlayer(_videoController),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 50.0, right: 25.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: FaIcon(
                    FontAwesomeIcons.x,
                    color: Styles.backgroundColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: videoPlaybackPageController.when(
                    data: (data) {
                      if (data != null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          child: UploadVideoButton(
                            ref: ref,
                            status: UploadVideoStatus.success,
                          ),
                        );
                      } else {
                        return UploadVideoButton(
                          ref: ref,
                          status: UploadVideoStatus.upload,
                          onPressed: () async {
                            await ref
                                .read(videoPlayBackPageControllerProvider
                                    .notifier)
                                .uploadAndCreateVideo();
                          },
                        );
                      }
                    },
                    error: (error, stack) => Text(
                      '${Constants.somethingWentWrongTxt} : ${error.toString()}',
                    ),
                    loading: () => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      child: UploadVideoButton(
                        ref: ref,
                        status: UploadVideoStatus.loading,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
