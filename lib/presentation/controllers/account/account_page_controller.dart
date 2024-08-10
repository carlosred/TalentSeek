import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_seek/data/providers/data_providers.dart';

import '../../../domain/user/user.dart';

part 'account_page_controller.g.dart';

@Riverpod(keepAlive: true)
class AccountPageController extends _$AccountPageController {
  @override
  Future<User?> build() async {
    var userLogged = ref.read(userAuthProvider);
    return userLogged;
  }

  Future<void> getUserUpdated() async {
    state = const AsyncLoading();
    try {
      var userLoggedUpdated =
          await ref.read(userRepositoryProvider).getUserUpdated();
      ref.read(userAuthProvider.notifier).state = userLoggedUpdated;
      state = AsyncData(userLoggedUpdated);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }

  Future<void> updateUser({
    required String newName,
  }) async {
    state = const AsyncLoading();
    try {
      var userLoggedUpdated =
          await ref.read(userRepositoryProvider).updateUser(newName: newName);
      ref.read(userAuthProvider.notifier).state = userLoggedUpdated;
      state = AsyncData(userLoggedUpdated);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }
}
