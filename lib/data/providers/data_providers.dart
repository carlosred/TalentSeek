import 'package:riverpod/riverpod.dart';

import 'package:talent_seek/data/clients/talent_seek_client.dart';
import 'package:talent_seek/data/repositories/auth_repository.dart';
import 'package:talent_seek/data/repositories/user_repository.dart';
import 'package:talent_seek/data/repositories/video_repository.dart';

import '../../domain/user/user.dart';

var talentSeekClient = TalentSeekClient();

var videoRepositoryProvider = Provider<VideoRepository>(
  (ref) => VideoRepository(talentSeekClient: talentSeekClient),
);

var userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(talentSeekClient: talentSeekClient),
);

var authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(talentSeekClient: talentSeekClient),
);

var userAuthProvider = StateProvider<User?>((ref) => null);
