import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talent_seek/presentation/controllers/camera/camera_controller.dart';

import '../../utils/styles.dart';
import '../providers/presentation_providers.dart';

class RecordingButton extends ConsumerStatefulWidget {
  @override
  _RecordingButtonState createState() => _RecordingButtonState();
}

class _RecordingButtonState extends ConsumerState<RecordingButton> {
  CameraTalentSeekController? cameraController;
  bool isRecording = false;

  @override
  void initState() {
    cameraController = ref.read(cameraControllerProvider);
    super.initState();
  }

  void _toggleRecording() async {
    if (cameraController!.getCameraController.value.isInitialized &&
        cameraController!.getCameraController.value.isRecordingVideo == false) {
      await cameraController!.startRecording();
      isRecording = true;
    } else if (cameraController!.getCameraController.value.isInitialized &&
        cameraController!.getCameraController.value.isRecordingVideo == true) {
      isRecording = false;
      await cameraController!.stopVideoRecording();

      ref.read(recordedVideoProvider.notifier).state =
          cameraController!.getVideoRecorded;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleRecording,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Container(
          key: ValueKey<bool>(isRecording),
          decoration: BoxDecoration(
            color: isRecording ? Colors.red : Styles.backgroundColor,
            shape: BoxShape.circle,
          ),
          width: 80.0,
          height: 80.0,
          child: Center(
            child: Icon(
              isRecording ? FontAwesomeIcons.pause : FontAwesomeIcons.circle,
              color: Colors.white,
              size: 40.0,
            ),
          ),
        ),
      ),
    );
  }
}
