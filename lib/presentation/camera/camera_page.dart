import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:talent_seek/presentation/providers/presentation_providers.dart';
import 'package:talent_seek/presentation/widgets/recording_button.dart';
import 'package:video_player/video_player.dart';

import '../widgets/recording_timer.dart';
import 'video_playback_page.dart';

class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({super.key});

  @override
  ConsumerState<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage> {
  late CameraController controller;
  late VideoPlayerController? _videoPlayerController;
  File? videoRecorded;
  var _aspectRatio;

  @override
  void initState() {
    ref.listenManual(recordedVideoProvider, (previous, next) async {
      if (next != null) {
        videoRecorded = next;
        _videoPlayerController = VideoPlayerController.file(videoRecorded!);
        await _videoPlayerController!.initialize().then((value) {
          _videoPlayerController!.play();
          _videoPlayerController!.setLooping(true);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VideoPlayBackPage(
                videoController: _videoPlayerController!,
                aspectRatio: _aspectRatio,
              ),
            ),
          );
        });
      }
    });

    controller = ref.read(cameraControllerProvider).getCameraController;
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    var isRecording = ref.watch(isRecordingProvider);
    if (!controller.value.isInitialized) {
      return Container();
    }

    const double previewAspectRatio = 0.7;

    _aspectRatio = controller.value.aspectRatio / previewAspectRatio;
    return Scaffold(
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
                    scale: _aspectRatio,
                    child: Center(
                      child: CameraPreview(controller),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                bottom: 50.0,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RecordingButton(),
              ),
            ),
            isRecording
                ? const Padding(
                    padding: EdgeInsets.only(
                      top: 50.0,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: RecordingTimer(),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
