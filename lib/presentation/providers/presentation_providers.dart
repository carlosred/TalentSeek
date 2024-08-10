import 'dart:io';

import 'package:riverpod/riverpod.dart';
import 'package:talent_seek/presentation/controllers/camera/camera_controller.dart';

import '../../domain/video/video.dart';

var currentVideoIndex = StateProvider<int>((ref) => 0);

var videoListProvider = StateProvider<List<Video>?>((ref) => null);

var tabIndexProvider = StateProvider<int>((ref) => 0);

var cameraControllerProvider = StateProvider<CameraTalentSeekController>(
  (ref) => CameraTalentSeekController(),
);

var recordedVideoProvider = StateProvider<File?>((ref) => null);

var videoObjectProvider = StateProvider<Video?>((ref) => null);
