import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_seek/data/providers/data_providers.dart';
import 'package:talent_seek/presentation/providers/presentation_providers.dart';

import '../../../domain/video/video.dart';

part 'video_playback_page_controller.g.dart';

@Riverpod(keepAlive: true)
class VideoPlayBackPageController extends _$VideoPlayBackPageController {
  @override
  Future<Video?> build() async {
    return null;
  }

  Future<void> uploadAndCreateVideo() async {
    state = const AsyncLoading();
    try {
      var videoFile = ref.read(recordedVideoProvider);

      var videoUploadedWithoutUrl = await ref
          .read(videoRepositoryProvider)
          .uploadVideo(videoFile: videoFile!);

      if (videoUploadedWithoutUrl != null) {
        var videoObject = ref.read(videoObjectProvider);
        var videoObjectCreated = await ref
            .read(videoRepositoryProvider)
            .createVideoDocument(
                videoObjectWithoutUrl: videoObject!,
                videoUrl: videoUploadedWithoutUrl);
        state = AsyncData(videoObjectCreated);
      } else {
        state = const AsyncData(null);
      }
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }
}
