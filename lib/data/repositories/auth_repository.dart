import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talent_seek/data/clients/talent_seek_client.dart';
import 'package:talent_seek/domain/user/user.dart';

class AuthRepository {
  final TalentSeekClient talentSeekClient;

  AuthRepository({
    required this.talentSeekClient,
  });

  Future<User?> loginWithGoogle() async {
    User? result;
    try {
      result = await talentSeekClient.loginWithGoogle();
    } catch (e) {
      debugPrint('error: $e');
    }

    return result;
  }

  Future<DocumentReference?> getIdUserLogged(
      {required String registeredEmail}) async {
    DocumentReference? result;
    try {
      result = await talentSeekClient.getIdUserLogged(
          registeredEmail: registeredEmail);
    } catch (e) {
      debugPrint('error: $e');
    }

    return result;
  }
}
