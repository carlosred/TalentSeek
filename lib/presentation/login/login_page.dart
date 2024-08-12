import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_seek/presentation/discover/discover_page.dart';
import 'package:talent_seek/presentation/home/home_page.dart';
import 'package:talent_seek/presentation/providers/presentation_providers.dart';
import 'package:talent_seek/utils/styles.dart';

import '../../utils/constants.dart';
import '../../utils/enum.dart';
import '../controllers/login/login_page_controller.dart';
import '../widgets/login_button.dart';
import 'package:animate_do/animate_do.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    ref.read(cameraControllerProvider).initializeCameras();
    ref.listenManual(loginPageControllerProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var loginPageController = ref.watch(loginPageControllerProvider);
    return SafeArea(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: Container(
            height: height,
            width: width,
            decoration: Styles.backgroundGradient,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideInLeft(
                  duration: Durations.extralong1,
                  child: Text(
                    'TalentSeek',
                    style: Styles.textStyleTittle.copyWith(fontSize: 45.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                loginPageController.when(
                  data: (data) {
                    if (data != null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                        child: LoginButton(
                          ref: ref,
                          status: LoginStatus.success,
                        ),
                      );
                    } else {
                      return SlideInRight(
                        duration: Durations.extralong1,
                        child: LoginButton(
                          ref: ref,
                          status: LoginStatus.login,
                          onPressed: () async {
                            await ref
                                .read(loginPageControllerProvider.notifier)
                                .loginWithGoogle();
                          },
                        ),
                      );
                    }
                  },
                  error: (error, stack) => Text(
                    '${Constants.somethingWentWrongTxt} : ${error.toString()}',
                  ),
                  loading: () => Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    child: LoginButton(
                      ref: ref,
                      status: LoginStatus.loading,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
