import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_seek/presentation/controllers/discover/discover_page_controller.dart';
import 'package:talent_seek/presentation/providers/presentation_providers.dart';
import 'package:talent_seek/presentation/widgets/video_reel.dart';

class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(discoverPageControllerProvider.notifier).getVideos();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var discoverPageController = ref.watch(discoverPageControllerProvider);

    return Scaffold(
      body: SizedBox.expand(
        child: discoverPageController.when(
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
                  videoPlayerController: data[index] ?? null,
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          error: (error, stackTrace) => const Center(
            child: Text('something wrong happens =( '),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
