import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/ui/home/widgets/bottom_sheet.dart';
import 'package:music_app/ui/home/widgets/on_long_press_dialog.dart';
import 'package:music_app/ui/home/widgets/visible_bottom_sheet.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/text_style.dart';

class PlaylistScreen extends StatefulWidget {
  final String namePlaylist;

  const PlaylistScreen({super.key, required this.namePlaylist});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer player = AudioPlayer();
  late AnimationController animationController;
  late CurvedAnimation curvedAnimation;
  late Animation animation;
  late Directory dir;
  List<FileSystemEntity> list = [];

  bool isPlaying = false;
  bool isShowBottomSheet = false;
  int activeSongIndex = -1;
  int slashIndexOfName = -1;
  String activeSongName = "";
  List<String> _nameSongs = [];

  @override
  void initState() {
    init();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    curvedAnimation =
        CurvedAnimation(parent: animationController, curve: Curves.linear);
    animation = Tween(begin: 0.0, end: pi * 2).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MusicAppColor.C_0F0F1D,
      body: SafeArea(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/favorite_playlist.png",
                      width: 60,
                    ),
                    Text(
                      widget.namePlaylist,
                      style: MusicAppTextStyle.w500,
                    )
                  ],
                )),
            Expanded(
                child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () async {
                  animationController.addListener(
                    () => {
                      setState(() => {}),
                    },
                  );
                  animationController.repeat();
                  isPlaying = true;
                  isShowBottomSheet = true;
                  animationController.repeat();
                  activeSongIndex = index;
                  activeSongName = _nameSongs[index].split("-")[0];
                  player.play(DeviceFileSource(
                      GetStorage().read("favorites")[index].path));
                  setState(() {});
                },
                onLongPress: () => {onLongPressDialog(context)},
                child: ListTile(
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset("assets/images/default_image.jpg")),
                  title: Text(
                    _nameSongs[index].split("-")[0].toString(),
                    style: MusicAppTextStyle.w500
                        .copyWith(color: MusicAppColor.white),
                  ),
                  subtitle: Text(
                    _nameSongs[index].split("-").length > 1
                        ? _nameSongs[index].split("-")[1]
                        : "Undifined",
                    style: MusicAppTextStyle.w500
                        .copyWith(color: MusicAppColor.grey),
                  ),
                  trailing: activeSongIndex == index
                      ? LottieBuilder.asset(
                          "assets/lotties/default_music.json",
                          width: 30,
                        )
                      : const SizedBox(),
                ),
              ),
            )),
            visibility(
              context: context,
              isShowBottomSheet: isShowBottomSheet,
              tapToBottomSheet: () async {
                await bottomsheet(
                  context: context,
                  index: activeSongIndex,
                  nameSongs: _nameSongs,
                  songs: GetStorage().read("favorites"),
                  player: player,
                  isPlaying: isPlaying,
                );
              },
              tapToPlay: () async {
                isPlaying = !isPlaying;
                isPlaying ? await player.resume() : await player.pause();
                isPlaying
                    ? animationController.repeat()
                    : animationController.stop();
                setState(() {});
              },
              activeSongName: activeSongName,
              animation: animation,
              isPlaying: isPlaying,
              player: player,
            ),
          ],
        ),
      ),
    );
  }

  init() async {
    list = await GetStorage().read("favorites");
    for (var i = 0; i < list.length; i++) {
      for (var j = list[i].path.length - 1; j >= 0; j--) {
        if (list[i].path[j] == "/") {
          slashIndexOfName = j;
          break;
        }
      }
    }
    for (var i = 0; i < list.length; i++) {
      _nameSongs.add(GetStorage().read("favorites")[i].path.substring(
          slashIndexOfName + 1, GetStorage().read("favorites")[i].path.length));
    }
    setState(() {});
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
