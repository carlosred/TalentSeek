import 'package:flutter/material.dart';

class VideoProgressIndicatorTalentSeek extends StatelessWidget {
  const VideoProgressIndicatorTalentSeek({
    super.key,
    required this.size,
    required double progress,
  }) : _progress = progress;

  final Size size;
  final double _progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: size.width,
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: 1.0,
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: _progress,
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
