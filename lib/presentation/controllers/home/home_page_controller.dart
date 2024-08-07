import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_seek/data/providers/data_providers.dart';

import '../../../domain/video/video.dart';

part 'home_page_controller.g.dart';

@Riverpod(keepAlive: true)
class HomePageController extends _$HomePageController {
  @override
  Future<List<Video>?> build() async {
    return null;
  }

  Future<void> getVideos() async {
    state = const AsyncLoading();
    try {
      var videoList = await ref.read(videoRepositoryProvider).getVideos();

      state = AsyncData(videoList);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }
}
