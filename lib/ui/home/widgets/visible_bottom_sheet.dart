import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/text_style.dart';

Widget visibility({
  required BuildContext context,
  required bool isShowBottomSheet,
  required VoidCallback tapToBottomSheet,
  required VoidCallback tapToPlay,
  required bool isPlaying,
  required AudioPlayer player,
  required Animation animation,
  required String activeSongName,
}) {
  return Visibility(
    visible: isShowBottomSheet,
    child: GestureDetector(
      onTap: tapToBottomSheet,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: MusicAppColor.C_404C6C,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(children: [
          Transform.rotate(
            angle: animation.value,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  "assets/images/default_image.jpg",
                  width: 50,
                ),
              ),
            ),
          ),
          Text(activeSongName,
              style: MusicAppTextStyle.w700.copyWith(fontSize: 16)),
          const Spacer(),
          IconButton(
            onPressed: tapToPlay,
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              size: 30,
              color: MusicAppColor.white,
            ),
          )
        ]),
      ),
    ),
  );
}
