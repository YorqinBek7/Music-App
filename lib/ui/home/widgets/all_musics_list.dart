import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/ui/home/widgets/on_long_press_dialog.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/text_style.dart';

class AllMusicsList extends StatelessWidget {
  List<FileSystemEntity> songs;
  List<String> nameSongs;
  int activeSongIndex;
  bool isPlaying;

  String activeSongName;
  AudioPlayer player;

  AllMusicsList({
    super.key,
    required this.songs,
    required this.nameSongs,
    required this.activeSongIndex,
    required this.isPlaying,
    required this.activeSongName,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: songs.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () async {
          isPlaying = true;
          activeSongIndex = index;
          activeSongName = nameSongs[index].split("-")[0];
          player.play(DeviceFileSource(songs[index].path));
        },
        onLongPress: () => {onLongPressDialog(context)},
        child: ListTile(
          leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset("assets/images/default_image.jpg")),
          title: Text(
            nameSongs[index].split("-")[0].toString(),
            style: MusicAppTextStyle.w500.copyWith(color: MusicAppColor.white),
          ),
          subtitle: Text(
            nameSongs[index].split("-").length > 1
                ? nameSongs[index].split("-")[1]
                : "Undifined",
            style: MusicAppTextStyle.w500.copyWith(color: MusicAppColor.grey),
          ),
          trailing: activeSongIndex == index
              ? LottieBuilder.asset(
                  "assets/lotties/default_music.json",
                  width: 30,
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
