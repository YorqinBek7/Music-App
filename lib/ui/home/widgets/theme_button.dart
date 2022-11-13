import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:music_app/data/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ThemeButton extends StatefulWidget {
  const ThemeButton({super.key});

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton> {
  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      minWidth: 90.0,
      minHeight: 40.0,
      initialLabelIndex: 0,
      cornerRadius: 20.0,
      activeFgColor: Colors.white,
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.white,
      totalSwitches: 2,
      icons: const [Icons.light_mode, Icons.dark_mode],
      iconSize: 30.0,
      activeBgColors: const [
        [Colors.black45, Colors.black26],
        [Colors.yellow, Colors.orange]
      ],
      animate: true,
      curve: Curves.bounceInOut,
      onToggle: (index) {
        setState(() {
          StorageRepository.putDouble("isDark", index!.toDouble());
          StorageRepository.getDouble("isDark") == 1
              ? AdaptiveTheme.of(context).setDark()
              : AdaptiveTheme.of(context).setLight();
        });
      },
    );
  }
}
