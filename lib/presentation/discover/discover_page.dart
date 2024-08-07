import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_seek/data/providers/data_providers.dart';
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Discover Page'),
      ),
      body: SizedBox.expand(
        child: discoverPageController.when(
          data: (data) {
            if (data != null) {
              var videoList = ref.read(videoListProvider);
              return PageView.builder(
                onPageChanged: (value) {
                  ref.read(currentVideoIndex.notifier).state = value;
                },
                itemCount: data.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) => VideoReelWidget(
                  index: index,
                  video: videoList?[index],
                  videoPlayerController: data[index],
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
