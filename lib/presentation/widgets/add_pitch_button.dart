import 'package:flutter/material.dart';
import 'package:talent_seek/presentation/widgets/create_pitch_dialog.dart';
import 'package:talent_seek/utils/constants.dart';

import '../../utils/styles.dart';

class AddPitchButton extends StatelessWidget {
  const AddPitchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const CreatePitchDialog(),
          useSafeArea: true,
          useRootNavigator: true,
        );
      },
      splashColor: Colors.white,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Styles.backgroundColor, // You can customize the color
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_box_rounded,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              Constants.createPitchText,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
