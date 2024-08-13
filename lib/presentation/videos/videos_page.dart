import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_seek/presentation/controllers/videos/videos_page_controller.dart';
import 'package:talent_seek/presentation/providers/presentation_providers.dart';
import 'package:talent_seek/presentation/widgets/video_reel.dart';

import '../../domain/video/video.dart';
import '../../utils/styles.dart';

class VideosPage extends ConsumerStatefulWidget {
  const VideosPage({
    super.key,
    required this.videos,
  });

  final List<Video> videos;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideosPageState();
}

class _VideosPageState extends ConsumerState<VideosPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(videosPageControllerProvider.notifier)
          .getVideoControllers(videos: widget.videos);
    });

    super.initState();
  }

  @override
  void dispose() {
    ref.read(videosPageControllerProvider.notifier).disposeVideoControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var videosPageController = ref.watch(videosPageControllerProvider);

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            decoration: Styles.backgroundGradient,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/icon.png',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SizedBox.expand(
          child: videosPageController.when(
            data: (data) {
              if (data != null) {
                var videoList = ref.read(videoListProvider);
                return PageView.builder(
                  onPageChanged: (value) {
                    ref.read(currentVideoIndex.notifier).state = value;
                    if (value >= 1 && value < data.length - 1) {
                      if (data[value + 1]!.value.isInitialized == false) {
                        data[value + 1]!.initialize();
                      }
                    }
                  },
                  itemCount: data.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => VideoReelWidget(
                    index: index,
                    video: videoList?[index],
                    videoPlayerController: data[index],
                    fromVideosPage: true,
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
            error: (error, stackTrace) => Center(
              child: Text('something wrong happens =( $error'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
