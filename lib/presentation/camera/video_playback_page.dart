import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talent_seek/presentation/controllers/account/account_page_controller.dart';

import 'package:talent_seek/presentation/controllers/camera/video_playback_page_controller.dart';
import 'package:talent_seek/presentation/providers/presentation_providers.dart';
import 'package:talent_seek/presentation/widgets/upload_video_button.dart';
import 'package:talent_seek/utils/enum.dart';
import 'package:video_player/video_player.dart';

import '../../utils/constants.dart';
import '../../utils/styles.dart';

class VideoPlayBackPage extends ConsumerStatefulWidget {
  const VideoPlayBackPage({
    super.key,
    required this.videoController,
    required this.aspectRatio,
  });
  final VideoPlayerController videoController;
  final double aspectRatio;
  @override
  ConsumerState<VideoPlayBackPage> createState() => _VideoPlayBackPageState();
}

class _VideoPlayBackPageState extends ConsumerState<VideoPlayBackPage> {
  @override
  void initState() {
    widget.videoController.play();
    ref.listenManual(videoPlayBackPageControllerProvider,
        (previous, next) async {
      if (next.hasValue && next.value != null) {
        ref.read(accountPageControllerProvider.notifier).getUserUpdated();
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        // Navigator.of(context).popUntil((route) => false);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.videoController.dispose();
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
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: (widget.videoController.value.size.width * 1.20),
                    height: widget.videoController.value.size.height,
                    child: VideoPlayer(widget.videoController),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0, right: 25.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(recordedVideoProvider.notifier).state = null;
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.x,
                      color: Styles.backgroundColor,
                    ),
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
