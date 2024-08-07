import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:talent_seek/presentation/providers/presentation_providers.dart';
import 'package:talent_seek/presentation/widgets/recording_button.dart';
import 'package:video_player/video_player.dart';

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
  @override
  void initState() {
    ref.listenManual(recordedVideoProvider, (previous, next) async {
      if (next != null) {
        videoRecorded = next;
        _videoPlayerController = VideoPlayerController.file(videoRecorded!);
        await _videoPlayerController!.initialize().then((value) {
          _videoPlayerController!.play();
          _videoPlayerController!.setLooping(true);

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const VideoPlayBackPage(),
          ));
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
    if (!controller.value.isInitialized) {
      return Container();
    }
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          if (videoRecorded == null) ...[
            CameraPreview(controller),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 50.0,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RecordingButton(),
              ),
            )
          ],
          if (videoRecorded != null && _videoPlayerController != null) ...[
            VideoPlayer(_videoPlayerController!),
          ]
        ]),
      ),
    );
  }
}
