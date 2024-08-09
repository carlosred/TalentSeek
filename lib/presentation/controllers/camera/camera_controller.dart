import 'dart:io';

import 'package:camera/camera.dart';

class CameraTalentSeekController {
  late List<CameraDescription> _cameras;
  late File? _videoRecorded;

  CameraController get getCameraController => controller;

  File? get getVideoRecorded => _videoRecorded;

  late CameraController controller;
  Future<void> initializeCameras() async {
    _cameras = await availableCameras();

    controller = CameraController(_cameras[0], ResolutionPreset.max);
  }

  Future<void> startRecording() async {
    controller.startVideoRecording();
  }

  Future<void> pauseRecording() async {
    controller.pauseVideoRecording();
  }

  Future<void> stopVideoRecording() async {
    var videoRecorded = await controller.stopVideoRecording();
    _videoRecorded = File(videoRecorded.path);
  }
}
