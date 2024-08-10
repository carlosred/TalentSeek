import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_seek/data/clients/talent_seek_client.dart';
import 'package:talent_seek/domain/user/user.dart';

import '../../domain/video/video.dart';

class UserRepository {
  final TalentSeekClient talentSeekClient;

  UserRepository({
    required this.talentSeekClient,
  });

  Future<User?> getUserUpdated() async {
    User? userUpdated;
    try {
      userUpdated = await talentSeekClient.getUserLogged();
    } catch (e) {
      userUpdated = null;
    }
    return userUpdated;
  }

  Future<User?> updateUser({required String newName}) async {
    User? userUpdated;
    try {
      userUpdated = await talentSeekClient.updateUser(newName: newName);
    } catch (e) {
      userUpdated = null;
    }
    return userUpdated;
  }
}
