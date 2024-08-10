import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:talent_seek/data/clients/talent_seek_client.dart';
import 'package:talent_seek/domain/user/user.dart';
import 'package:talent_seek/domain/video/video.dart';

class VideoRepository {
  final TalentSeekClient talentSeekClient;

  VideoRepository({
    required this.talentSeekClient,
  });

  Future<List<Video>?> getVideos() async {
    List<Video>? videos;
    try {
      videos = await talentSeekClient.getVideos();
    } catch (e) {
      videos = null;
    }
    return videos;
  }

  Future<String?> uploadVideo({required File videoFile}) async {
    String? videoUploadedUrl;
    try {
      videoUploadedUrl =
          await talentSeekClient.uploadVideo(videoFile: videoFile);
    } catch (e) {
      videoUploadedUrl = null;
    }
    return videoUploadedUrl;
  }

  Future<Video?> createVideoDocument(
      {required Video videoObjectWithoutUrl, required String videoUrl}) async {
    Video? videoCreated;
    try {
      videoCreated = await talentSeekClient.createVideoDocument(
        videoUrl: videoUrl,
        videoObjectWithoutUrl: videoObjectWithoutUrl,
      );
    } catch (e) {
      videoCreated = null;
    }
    return videoCreated;
  }
}
