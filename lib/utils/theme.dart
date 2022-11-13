import 'package:flutter/material.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/text_style.dart';

class MusicAppTheme {
  static ThemeData lightMode() {
    return ThemeData(
        scaffoldBackgroundColor: MusicAppColor.C_FAFAFA,
        backgroundColor: MusicAppColor.C_FAFAFA,
        textTheme: TextTheme(
            headline4: MusicAppTextStyle.w500
                .copyWith(fontSize: 24, color: MusicAppColor.black),
            headline5:
                MusicAppTextStyle.w500.copyWith(color: MusicAppColor.black),
            headline6: MusicAppTextStyle.w500.copyWith(
              color: MusicAppColor.grey,
              fontSize: 12,
            )),
        buttonColor: MusicAppColor.C_080812);
  }

  static ThemeData darkMode() {
    return ThemeData(
        scaffoldBackgroundColor: MusicAppColor.C_080812,
        backgroundColor: MusicAppColor.C_080812,
        textTheme: TextTheme(
          headline4: MusicAppTextStyle.w500.copyWith(fontSize: 24),
          headline5:
              MusicAppTextStyle.w500.copyWith(color: MusicAppColor.white),
          headline6: MusicAppTextStyle.w500
              .copyWith(color: MusicAppColor.grey, fontSize: 12),
        ),
        buttonColor: MusicAppColor.white);
  }
}
