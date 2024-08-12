import 'package:flutter/material.dart';
import 'package:talent_seek/presentation/account/account_page.dart';
import 'package:talent_seek/presentation/camera/camera_page.dart';
import 'package:talent_seek/presentation/camera/video_playback_page.dart';
import 'package:talent_seek/presentation/home/home_page.dart';
import 'package:talent_seek/presentation/login/login_page.dart';

import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.loginRoute:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
        );

      case Routes.homeRoute:
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );

      case Routes.cameraRoute:
        return MaterialPageRoute(
          builder: (context) => const CameraPage(),
        );

      case Routes.accountRoute:
        return MaterialPageRoute(
          builder: (context) => const AccountPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
        );
    }
  }
}
