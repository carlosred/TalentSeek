import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_seek/data/providers/data_providers.dart';
import 'package:talent_seek/presentation/providers/presentation_providers.dart';
import 'package:video_player/video_player.dart';

import '../../../domain/video/video.dart';

part 'videos_page_controller.g.dart';

class VideosPageController extends _$VideosPageController {
  late List<VideoPlayerController?>? _videoControllers;
  @override
  Future<List<VideoPlayerController?>?> build() async {
    return null;
  }

  Future<void> getVideoControllers({required List<Video> videos}) async {
    state = const AsyncLoading();
    try {
      var videoList = videos;
      _videoControllers = List.generate(
        videoList.length,
        (index) => VideoPlayerController.networkUrl(
          Uri.parse(videoList[index].videoUrl ?? ''),
        ),
      );
      ref.read(currentVideoIndex.notifier).state = 0;
      var firstVideoIndex = ref.read(currentVideoIndex);
      await initializeCurrentVideoController(
        currentIndexVideoController: firstVideoIndex,
      );

      state = AsyncData(_videoControllers);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }

  Future<void> initializeCurrentVideoController(
      {required int currentIndexVideoController}) async {
    await _videoControllers![currentIndexVideoController]!
        .initialize()
        .then((value) {
      if (currentIndexVideoController != _videoControllers!.length - 1) {
        _videoControllers![currentIndexVideoController + 1]!
            .initialize()
            .then((value) {});
      }
    });
  }

  deleteVideoControllerDisposed({required int index}) {
    var currentVideoControllerList = _videoControllers;
    currentVideoControllerList![index] = null;

    state = AsyncData(currentVideoControllerList);
  }
}
