import 'package:riverpod/riverpod.dart';

import '../../domain/video/video.dart';

var currentVideoIndex = StateProvider<int>((ref) => 0);

var videoListProvider = StateProvider<List<Video>?>((ref) => null);
