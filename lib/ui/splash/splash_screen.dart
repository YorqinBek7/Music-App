import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, homeScreen);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MusicAppColor.C_080812,
      body: Center(
        child: LottieBuilder.asset("assets/lotties/splash_lottie.json"),
      ),
    );
  }
}
