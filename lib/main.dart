import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:music_app/cubit/music_cubit.dart';
import 'package:music_app/data/shared_preferences.dart';
import 'package:music_app/ui/router.dart';
import 'package:music_app/utils/constants.dart';
import 'package:music_app/utils/theme.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await StorageRepository.getInstance();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(App(
    savedThemeMode: savedThemeMode,
  ));
}

class App extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const App({super.key, required this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MusicCubit(),
      child: AdaptiveTheme(
        light: MusicAppTheme.lightMode(),
        dark: MusicAppTheme.darkMode(),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
          title: 'Adaptive Theme Demo',
          theme: theme,
          darkTheme: darkTheme,
          home: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Music App',
            theme: theme,
            darkTheme: darkTheme,
            onGenerateRoute: MusicAppRouters.generateRoutes,
            initialRoute: homeScreen,
          ),
        ),
      ),
    );
  }
}
