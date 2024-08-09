import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talent_seek/presentation/account/account_page.dart';
import 'package:talent_seek/presentation/discover/discover_page.dart';

import '../providers/presentation_providers.dart';
import '../widgets/appbar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  void _onItemTapped(int index) {
    setState(() {
      ref.read(tabIndexProvider.notifier).state = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;

    var tabIndex = ref.watch(tabIndexProvider);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: TalentSeekAppBar(),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: IndexedStack(
          index: tabIndex,
          children: const [DiscoverPage(), AccountPage()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.compass),
            label: 'Descubre',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userAstronaut),
            label: 'Portafolio',
          ),
        ],
        currentIndex: tabIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
