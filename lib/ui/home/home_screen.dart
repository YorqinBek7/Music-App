import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/ui/home/widgets/bottom_sheet.dart';
import 'package:music_app/ui/home/widgets/on_long_press_dialog.dart';
import 'package:music_app/ui/home/widgets/playlists.dart';
import 'package:music_app/ui/home/widgets/visible_bottom_sheet.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/constants.dart';
import 'package:music_app/utils/functions.dart';
import 'package:music_app/utils/text_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer player = AudioPlayer();

  late AnimationController animationController;
  late CurvedAnimation curvedAnimation;
  late Animation animation;
  late Directory dir;

  bool isPlaying = false;
  bool isShowBottomSheet = false;
  int activeSongIndex = -1;
  int slashIndexOfName = -1;
  String activeSongName = "";

  List<FileSystemEntity> _files = [];
  List<FileSystemEntity> _songs = [];
  List<String> _nameSongs = [];
  List<List<FileSystemEntity>> playlists = [];

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    curvedAnimation =
        CurvedAnimation(parent: animationController, curve: Curves.linear);
    animation = Tween(begin: 0.0, end: pi * 2).animate(curvedAnimation);
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MusicAppColor.C_0F0F1D,
      appBar: AppBar(
        title: Text(
          "Music App",
          style: MusicAppTextStyle.w500.copyWith(fontSize: 24),
        ),
        backgroundColor: MusicAppColor.C_080812,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 10),
                Text("Your Playlist",
                    style: MusicAppTextStyle.w700.copyWith(fontSize: 24)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PlaylistContainers(
                      title: 'My favorites',
                      image: 'assets/images/favorite_playlist.png',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          playlistScreen,
                          arguments: "My Favorites",
                        );
                      },
                    ),
                    PlaylistContainers(
                      title: 'Best song 2022',
                      image: 'assets/images/new_musics.png',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          playlistScreen,
                          arguments: "Best songs 2022",
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text("Songs",
                    style: MusicAppTextStyle.w700.copyWith(fontSize: 24)),
                const SizedBox(height: 5),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _songs.length,
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
                      player.play(DeviceFileSource(_songs[index].path));
                      setState(() {});
                    },
                    onLongPress: () => {onLongPressDialog(context)},
                    child: ListTile(
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child:
                              Image.asset("assets/images/default_image.jpg")),
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
                ),
              ],
            ),
          ),
          visibility(
              context: context,
              isShowBottomSheet: isShowBottomSheet,
              tapToBottomSheet: () async {
                await bottomsheet(
                  context: context,
                  index: activeSongIndex,
                  nameSongs: _nameSongs,
                  songs: _songs,
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
              isPlaying: isPlaying,
              player: player,
              animation: animation,
              activeSongName: activeSongName),
        ],
      ),
    );
  }

  void init() async {
    getPemission();

    getMusicsFromStorage(directory: '/storage/emulated/0/Music/');
    getMusicsFromStorage(directory: '/storage/emulated/0/Download/');

    for (var i = 0; i < _songs.length; i++) {
      for (var j = _songs[i].path.length - 1; j >= 0; j--) {
        if (_songs[i].path[j] == "/") {
          slashIndexOfName = j;
          break;
        }
      }
      _nameSongs.add(_songs[i]
          .path
          .substring(slashIndexOfName + 1, _songs[i].path.length));
    }
    setState(() {});
    await GetStorage().write("favorites", _songs);
  }

  void getMusicsFromStorage({required String directory}) {
    dir = Directory(directory);
    _files = dir.listSync(recursive: true, followLinks: false);
    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      if (path.endsWith('.mp3')) _songs.add(entity);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
