import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/cubit/music_cubit.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/text_style.dart';

Widget visibility({
  required BuildContext context,
  required VoidCallback tapToBottomSheet,
  required VoidCallback tapToPlay,
  required AudioPlayer player,
}) {
  return Visibility(
    visible: context.read<MusicCubit>().isShowBottomSheet,
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
          LottieBuilder.asset(
            "assets/lotties/playing_music.json",
            animate: context.read<MusicCubit>().isPlaying,
            width: 75,
          ),
          Text(context.watch<MusicCubit>().activeSongName,
              style: MusicAppTextStyle.w700.copyWith(fontSize: 16)),
          const Spacer(),
          IconButton(
            onPressed: tapToPlay,
            icon: Icon(
              context.watch<MusicCubit>().isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              size: 30,
              color: MusicAppColor.white,
            ),
          )
        ]),
      ),
    ),
  );
}
