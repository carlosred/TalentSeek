import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CircularAccountAvatar extends StatelessWidget {
  final String initials;

  const CircularAccountAvatar({super.key, required this.initials});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: 125,
        height: 125,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 5,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: AutoSizeText(
              initials,
              style: const TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
