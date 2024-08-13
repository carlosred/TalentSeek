// ignore_for_file: library_private_types_in_public_api

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:talent_seek/domain/user/user.dart';

import '../../domain/video/video.dart';
import '../../utils/constants.dart';

class ExpandableVideoInfo extends StatefulWidget {
  final Video? videoInfo;

  const ExpandableVideoInfo({super.key, required this.videoInfo});
  @override
  _ExpandableVideoInfoState createState() => _ExpandableVideoInfoState();
}

class _ExpandableVideoInfoState extends State<ExpandableVideoInfo>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    var creatorUser = widget.videoInfo?.creatorUser as User;
    return GestureDetector(
      onTap: _toggleExpand,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _toggleExpand,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/user.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              creatorUser.name!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 2.0,
                            ),
                            Text(
                              widget.videoInfo?.label ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            if (widget.videoInfo?.roleSeeked != null &&
                                widget.videoInfo!.roleSeeked!.isNotEmpty)
                              AutoSizeText(
                                '${Constants.objective} - ${widget.videoInfo!.objectChallenge!}',
                                wrapWords: true,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Container(
                    child: _isExpanded
                        ? Text(
                            widget.videoInfo?.description ?? '',
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        : Text(
                            widget.videoInfo?.description ?? '',
                            textAlign: TextAlign.justify,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
