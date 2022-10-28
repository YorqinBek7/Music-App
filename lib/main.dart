import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music_app/ui/router.dart';
import 'package:music_app/utils/constants.dart';

void main() async {
  await GetStorage.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: MusicAppRouters.generateRoutes,
      initialRoute: splashScreen,
    );
  }
}
