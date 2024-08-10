import 'dart:io';

import 'package:talent_seek/data/clients/talent_seek_client.dart';

import '../../domain/video/video.dart';

class UserRepository {
  final TalentSeekClient talentSeekClient;

  UserRepository({
    required this.talentSeekClient,
  });

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
