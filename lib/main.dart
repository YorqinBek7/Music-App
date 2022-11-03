import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:music_app/cubit/music_cubit.dart';
import 'package:music_app/ui/router.dart';
import 'package:music_app/utils/constants.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MusicCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: MusicAppRouters.generateRoutes,
        initialRoute: homeScreen,
      ),
    );
  }
}
