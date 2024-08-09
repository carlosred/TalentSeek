import 'package:flutter/material.dart';

import '../../utils/styles.dart';

class TalentSeekAppBar extends StatelessWidget {
  const TalentSeekAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: Styles.backgroundGradient,
      child: Image.asset(
        'assets/images/icon.png',
        width: 40.0,
        height: 40.0,
        fit: BoxFit.contain,
      ),
    );
  }
}
