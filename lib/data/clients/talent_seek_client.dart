import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:talent_seek/domain/video/video.dart';
import 'package:talent_seek/domain/user/user.dart' as talentSeek;

import '../../utils/constants.dart';

class TalentSeekClient {
  final client = FirebaseFirestore.instance;

  Future<List<talentSeek.User>?> getUsers() async {
    List<talentSeek.User>? result;
    try {
      QuerySnapshot querySnapshot = await client.collection("challenges").get();

      final users = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      for (var element in users) {
        print(element.toString());
      }
      result = users.map((e) => talentSeek.User.fromJson(e)).toList();
    } catch (e) {
      result = null;
    }

    return result;
  }

  Future<List<Video>?> getVideos() async {
    List<Video>? result;
    try {
      QuerySnapshot querySnapshotVideos =
          await client.collection("videos").get();
      QuerySnapshot querySnapshotChallenges =
          await client.collection("challenges").get();
      final videos = querySnapshotVideos.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      final challenges = querySnapshotChallenges.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      final userVideos = videos.map((e) => Video.fromJson(e)).toList();

      final challengesVideos =
          challenges.map((e) => Video.fromJson(e)).toList();

      result = await _getUsersCreatorFromVideos(
          challenges: challengesVideos, videos: userVideos);
    } catch (e) {
      result = null;
    }

    return result;
  }

  Future<List<Video>> _getUsersCreatorFromVideos(
      {List<Video>? videos, List<Video>? challenges}) async {
    List<Video>? result = [];
    if (videos!.isNotEmpty) {
      for (var video in videos) {
        var videoReference = video.creatorUser as DocumentReference<Object?>;
        var videoObject = await videoReference.get();
        var creatorUserObject = talentSeek.User.fromJson(
            videoObject.data() as Map<String, dynamic>);

        var index = videos.indexOf(video);
        videos[index] = video.copyWith(creatorUser: creatorUserObject);
      }

      result.addAll([...videos]);
    }

    if (challenges!.isNotEmpty) {
      for (var challenge in challenges) {
        var challengeReference =
            challenge.creatorUser as DocumentReference<Object?>;
        var challengeObject = await challengeReference.get();
        var creatorUserObject = talentSeek.User.fromJson(
            challengeObject.data() as Map<String, dynamic>);

        var index = challenges.indexOf(challenge);
        challenges[index] = challenge.copyWith(creatorUser: creatorUserObject);
      }
      result.addAll([...challenges]);
    }
    result.shuffle();
    return result;
  }

  Future<String?> loginWithGoogle() async {
    const List<String> scopes = <String>[
      Constants.email,
    ];

    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: scopes,
    );
    final googleAccount = googleSignIn.signIn();

    final googleResponse = await googleAccount;
    final googleAuth = await googleResponse?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return Future.value(userCredential.user?.email ?? '');
  }
}
