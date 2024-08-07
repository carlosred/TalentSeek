import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talent_seek/data/providers/data_providers.dart';

part 'login_page_controller.g.dart';

@Riverpod(keepAlive: true)
class LoginPageController extends _$LoginPageController {
  @override
  Future<String?> build() async {
    return null;
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncLoading();
    try {
      var user = await ref.read(authRepositoryProvider).loginWithGoogle();
      ref.read(userAuthProvider.notifier).state = user;
      state = AsyncData(user);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }
}
