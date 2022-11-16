import 'package:flutter/material.dart';
import 'package:music_app/ui/home/home_screen.dart';
import 'package:music_app/utils/constants.dart';

class MusicAppRouters {
  static Route generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
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
