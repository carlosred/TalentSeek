import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talent_seek/data/providers/data_providers.dart';
import 'package:talent_seek/presentation/controllers/login/login_page_controller.dart';

import '../../utils/styles.dart';

class TalentSeekAppBar extends ConsumerWidget {
  const TalentSeekAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: Styles.backgroundGradient,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                ref.read(userAuthProvider.notifier).state = null;
                ref.read(loginPageControllerProvider.notifier).logout();
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: const FaIcon(
                  FontAwesomeIcons.arrowRightFromBracket,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/icon.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox()
        ],
      ),
    );
  }
}
