import 'package:firebase_core/firebase_core.dart';
import 'package:talent_seek/data/clients/talent_seek_client.dart';
import 'package:talent_seek/domain/user/user.dart';
import 'package:talent_seek/domain/video/video.dart';

class UserRepository {
  final TalentSeekClient talentSeekClient;

  UserRepository({
    required this.talentSeekClient,
  });

  Future<List<User>?> getUsers() async {
    List<User>? videos;
    try {} catch (e) {
      videos = null;
    }
    return videos;
  }
}
