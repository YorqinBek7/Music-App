import 'package:flutter/material.dart';
import 'package:music_app/ui/home/home_screen.dart';
import 'package:music_app/ui/splash/splash_screen.dart';

import 'package:music_app/utils/constants.dart';

class MusicAppRouters {
  static Route generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case splashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text("Route not founded")),
          ),
        );
    }
  }
}
