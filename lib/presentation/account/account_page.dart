import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:talent_seek/data/providers/data_providers.dart';
import 'package:talent_seek/presentation/videos/videos_page.dart';
import 'package:talent_seek/presentation/widgets/update_name_user_dialog.dart';
import 'package:talent_seek/utils/styles.dart';

import '../../domain/video/video.dart';
import '../widgets/add_pitch_button.dart';
import '../widgets/circular_account_avatar.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String getInitials({required String name}) {
    List<String> nameParts = name.split(' ');
    String initials = '';

    initials += nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();

    return initials;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    var userLogged = ref.watch(userAuthProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: width,
              height: height * 0.18,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CircularAccountAvatar(
                        initials: getInitials(
                            name: userLogged?.name ?? 'Unknow User'),
                      ),
                    ),
                    const SizedBox(
                      width: 25.0,
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                        ),
                        child: AutoSizeText(
                          userLogged?.name ?? 'Unknow User',
                          maxLines: 2,
                          softWrap: true,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => UpdateNameUserDialog(
                                      userName: userLogged!.name!,
                                    ),
                                    useSafeArea: true,
                                    useRootNavigator: true,
                                  );
                                },
                                child: const Icon(
                                  Icons.edit,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: AddPitchButton(),
            ),
            const SizedBox(
              height: 25.0,
            ),
            SizedBox(
              height: height,
              width: width,
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Styles.backgroundColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        Tab(
                          icon: FaIcon(
                            FontAwesomeIcons.video,
                            color: Styles.backgroundColor,
                          ),
                          text: 'Videos',
                        ),
                        Tab(
                          icon: FaIcon(
                            FontAwesomeIcons.flag,
                            color: Styles.backgroundColor,
                          ),
                          text: 'Challenges',
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          buildGridView(
                            videos: userLogged!.videos,
                          ),
                          buildGridView(
                            videos: userLogged.challenges,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridView({required List<dynamic>? videos, isChallenge}) {
    if (videos!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/empty_video.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(
              "Ups, al parecer no has creado aun un Pitch",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      int crossAxisCount = 2; // Always show 2 items per row
      double aspectRatio = 16 / 9;
      // Calculate the number of rows required
      int rowCount = (videos.length / crossAxisCount).ceil();

      // Calculate the height of each item
      double itemHeight =
          (MediaQuery.of(context).size.width / crossAxisCount) / aspectRatio;

      // Calculate the total height of the GridView
      double gridHeight = rowCount * itemHeight +
          (rowCount - 1) * 8.0; // Adding spacing between rows
      var videoList = videos as List<Video>;
      return SizedBox(
        height: gridHeight,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(), // Prevent scrolling
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
            childAspectRatio: aspectRatio,
          ),
          itemCount: videoList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VideosPage(
                    videos: videoList,
                  ),
                ));
              },
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://img.freepik.com/free-vector/flat-clapperboard-icon_1063-38.jpg',
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
