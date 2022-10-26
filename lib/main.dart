import 'package:flutter/material.dart';
import 'package:music_app/ui/router.dart';
import 'package:music_app/utils/constants.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: MusicAppRouters.generateRoutes,
      initialRoute: homeScreen,
    );
  }
}
