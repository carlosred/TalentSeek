import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:talent_seek/domain/video/video.dart';
// ignore: library_prefixes
import 'package:talent_seek/domain/user/user.dart' as talentSeek;
import 'package:uuid/uuid.dart';
import '../../utils/constants.dart';

class TalentSeekClient {
  final client = FirebaseFirestore.instance;

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

  Future<talentSeek.User?> _getVideosFromUserLogged(
      {required talentSeek.User userLogged}) async {
    talentSeek.User? result;

    try {
      List<Video>? videos = [];
      List<Video>? challenges = [];

      if (userLogged.videos!.isNotEmpty && userLogged.videos != null) {
        for (var video in userLogged.videos!) {
          var videoReference = video as DocumentReference<Object?>;
          var videoData = await videoReference.get();
          var videoObject =
              Video.fromJson(videoData.data() as Map<String, dynamic>);
          videos.add(videoObject);
        }
      }

      if (userLogged.challenges!.isNotEmpty && userLogged.challenges != null) {
        for (var challenge in userLogged.challenges!) {
          var challengeReference = challenge as DocumentReference<Object?>;
          var challengeData = await challengeReference.get();
          var challengeObject =
              Video.fromJson(challengeData.data() as Map<String, dynamic>);
          challenges.add(challengeObject);
        }
      }

      var userWithVideos =
          userLogged.copyWith(videos: videos, challenges: challenges);
      result = userWithVideos;
    } catch (e) {
      result = null;
    }

    return result;
  }

  Future<talentSeek.User?> loginWithGoogle() async {
    talentSeek.User? result;

    try {
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

      var emailUser = userCredential.user?.email;

      var userRef = client.collection("users");

      final userquery =
          await userRef.where("registeredEmail", isEqualTo: emailUser).get();

      var userJson =
          userquery.docs.map((doc) => doc.data()).toList().firstOrNull;

      if (userJson != null) {
        var userLogged = talentSeek.User.fromJson(userJson);
        result = await _getVideosFromUserLogged(userLogged: userLogged);
      } else {
        var nameUser = userCredential.user?.displayName!;
        var newUser = await _registerWithGoogle(
            registeredEmail: emailUser!, name: nameUser!);
        result = await _getVideosFromUserLogged(userLogged: newUser!);
      }
    } catch (e) {
      result = null;
    }

    return result;
  }

  Future<talentSeek.User?> _registerWithGoogle(
      {required String registeredEmail, required String name}) async {
    talentSeek.User? result;

    try {
      var userRef = client.collection("users");

      final newUser = <String, dynamic>{
        'videos': [],
        'registeredEmail': registeredEmail,
        'name': name,
        'challenges': [],
      };

      var newId = const Uuid().v4();
      await userRef.doc(newId).set(newUser);

      final userquery = await userRef
          .where("registeredEmail", isEqualTo: registeredEmail)
          .get();

      var userJson =
          userquery.docs.map((doc) => doc.data()).toList().firstOrNull;
      if (userJson != null) {
        result = talentSeek.User.fromJson(userJson);
      }
    } catch (e) {
      result = null;
    }

    return result;
  }

  Future<DocumentReference?> getIdUserLogged(
      {required String registeredEmail}) async {
    var userRef = client.collection("users");
    final userquery = await userRef
        .where("registeredEmail", isEqualTo: registeredEmail)
        .get();

    var userDocument = userquery.docs.firstOrNull;

    return userDocument!.reference;
  }

  Future<talentSeek.User?> getUserLogged() async {
    talentSeek.User? result;
    var registeredEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    try {
      var userRef = client.collection("users");
      final userquery = await userRef
          .where("registeredEmail", isEqualTo: registeredEmail)
          .get();

      var userDocument = userquery.docs.firstOrNull;

      result = talentSeek.User.fromJson(userDocument!.data());
    } catch (e) {
      result = null;
    }
    return result;
  }

  Future<String?> uploadVideo({required File videoFile}) async {
    String? videoUrl;
    final storageRef = FirebaseStorage.instance.ref();
    var newIdVideo = const Uuid().v4();
    final videosRef = storageRef.child("videos/$newIdVideo.mp4");

    try {
      await videosRef.putFile(videoFile);
      videoUrl = await videosRef.getDownloadURL();
    } on FirebaseException catch (e) {
      debugPrint('The task of uploading the video fails ->$e');
      videoUrl = null;
    }
    return videoUrl;
  }

  Future<Video?> createVideoDocument(
      {required Video videoObjectWithoutUrl, required String videoUrl}) async {
    Video? result;
    CollectionReference videoRefs;

    var collection = '';
    if (videoObjectWithoutUrl.roleSeeked != null &&
        videoObjectWithoutUrl.roleSeeked!.isNotEmpty) {
      collection = 'challenges';
    } else {
      collection = 'videos';
    }

    videoRefs = client.collection(collection);
    try {
      final newVideo =
          videoObjectWithoutUrl.copyWith(videoUrl: videoUrl).toJson();

      var newId = const Uuid().v4();
      await videoRefs.doc(newId).set(newVideo);

      final videoDocument = await videoRefs.doc(newId).get();
      var videoJson = videoDocument.data() as Map<String, dynamic>;
      if (videoJson.isNotEmpty) {
        result = Video.fromJson(videoJson);
        await _updateVideoListOfUserLogged(
          newVideoId: newId,
          videoCreated: result,
          videoRefs: videoRefs,
          isChallenge: collection == 'challenges',
        );
      }
    } catch (e) {
      result = null;
    }

    return result;
  }

  Future<void> _updateVideoListOfUserLogged(
      {required String newVideoId,
      required Video videoCreated,
      required CollectionReference<Object?> videoRefs,
      required bool isChallenge}) async {
    var userRef = client.collection("users");
    var videoReference = videoCreated.creatorUser as DocumentReference<Object?>;
    var userCreator = await videoReference.get();
    final videoDocumentReference = videoRefs.doc(newVideoId);
    var userCreatorId = userCreator.id;

    if (isChallenge == false) {
      var newVideosList =
          talentSeek.User.fromJson(userCreator.data() as Map<String, dynamic>)
              .videos;
      newVideosList!.add(videoDocumentReference);

      await userRef.doc(userCreatorId).update({'videos': newVideosList});
    } else {
      var newVideosList =
          talentSeek.User.fromJson(userCreator.data() as Map<String, dynamic>)
              .challenges;
      newVideosList!.add(videoDocumentReference);

      await userRef.doc(userCreatorId).update({'challenges': newVideosList});
    }
  }

  Future<talentSeek.User?> updateUser({
    required String newName,
  }) async {
    var userRef = client.collection("users");

    var registeredEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    final userquery = await userRef
        .where("registeredEmail", isEqualTo: registeredEmail)
        .get();

    var userDocument = userquery.docs.firstOrNull;

    var userId = userDocument!.id;

    await userRef.doc(userId).update({'name': newName});

    return getUserLogged();
  }
}
