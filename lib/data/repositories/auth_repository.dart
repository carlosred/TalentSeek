import 'package:flutter/material.dart';
import 'package:talent_seek/data/clients/talent_seek_client.dart';

class AuthRepository {
  final TalentSeekClient talentSeekClient;

  AuthRepository({
    required this.talentSeekClient,
  });

  Future<String?> loginWithGoogle() async {
    String? result;
    try {
      result = await talentSeekClient.loginWithGoogle();
    } catch (e) {
      debugPrint('error: $e');
    }

    return result;
  }
}
