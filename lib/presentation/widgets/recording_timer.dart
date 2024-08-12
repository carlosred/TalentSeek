// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/camera/camera_controller.dart';
import '../providers/presentation_providers.dart';

class RecordingTimer extends ConsumerStatefulWidget {
  const RecordingTimer({super.key});

  @override
  _RecordingTimerState createState() => _RecordingTimerState();
}

class _RecordingTimerState extends ConsumerState<RecordingTimer> {
  late Timer _timer;
  int _seconds = 0;
  CameraTalentSeekController? cameraController;

  @override
  void initState() {
    cameraController = ref.read(cameraControllerProvider);
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      setState(() {
        _seconds++;
      });

      if (_seconds == 60) {
        await cameraController!.stopVideoRecording();

        ref.read(recordedVideoProvider.notifier).state =
            cameraController!.getVideoRecorded;

        ref.read(isRecordingProvider.notifier).state = false;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(_seconds),
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            const Icon(
              FontAwesomeIcons.solidCircle,
              color: Colors.red,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
