import 'package:riverpod/riverpod.dart';

import 'package:talent_seek/data/clients/firebase_client.dart';
import 'package:talent_seek/data/repositories/user_repository.dart';
import 'package:talent_seek/data/repositories/video_repository.dart';

var talentSeekClient = TalentSeekClient();

var videoRepositoryProvider = Provider<VideoRepository>(
  (ref) => VideoRepository(talentSeekClient: talentSeekClient),
);

var userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(talentSeekClient: talentSeekClient),
);
