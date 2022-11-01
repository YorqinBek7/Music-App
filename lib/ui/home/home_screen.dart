import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/cubit/music_cubit.dart';
import 'package:music_app/ui/home/widgets/bottom_sheet.dart';
import 'package:music_app/ui/home/widgets/on_long_press_dialog.dart';
import 'package:music_app/ui/home/widgets/playlists.dart';
import 'package:music_app/ui/home/widgets/visible_bottom_sheet.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/constants.dart';
import 'package:music_app/utils/functions.dart';
import 'package:music_app/utils/text_style.dart';
import 'dart:developer' as p;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer player = AudioPlayer();

  late Directory dir;

  List<FileSystemEntity> _files = [];
  List<FileSystemEntity> _songs = [];
  List<String> _nameSongs = [];
  List<List<FileSystemEntity>> playlists = [];
  Duration musicDuraition = const Duration();
  Duration currentPosition = const Duration();
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MusicAppColor.C_080812,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Music App",
            style: MusicAppTextStyle.w500.copyWith(fontSize: 24)),
        backgroundColor: MusicAppColor.C_080812,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 10),
                  Text("Your Playlist",
                      style: MusicAppTextStyle.w500.copyWith(fontSize: 24)),
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
                      style: MusicAppTextStyle.w500.copyWith(fontSize: 24)),
                  const SizedBox(height: 5),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _songs.length,
                    itemBuilder: (context, index) {
                      List<String> subtitle = _nameSongs[index].split("-");
                      return GestureDetector(
                        onTap: () async {
                          musicDuraition = (await player.getDuration())!;
                          currentPosition =
                              (await player.getCurrentPosition())!;
                          context.read<MusicCubit>().isPlaying = true;
                          context.read<MusicCubit>().isShowBottomSheet = true;
                          context.read<MusicCubit>().activeSongIndex = index;
                          context.read<MusicCubit>().activeSongName =
                              _nameSongs[index].split("-")[0];
                          await player
                              .play(DeviceFileSource(_songs[index].path));
                          setState(() {});
                        },
                        onLongPress: () => {onLongPressDialog(context)},
                        child: ListTile(
                          title: Text(
                            _nameSongs[index].split("-")[0].toString(),
                            style: MusicAppTextStyle.w500.copyWith(
                                color: MusicAppColor.white, fontSize: 14),
                          ),
                          subtitle: Text(
                            subtitle.length > 1
                                ? subtitle[1].substring(1, subtitle[1].length)
                                : "Undifined",
                            style: MusicAppTextStyle.w500.copyWith(
                                color: MusicAppColor.grey, fontSize: 12),
                          ),
                          trailing: context
                                      .read<MusicCubit>()
                                      .activeSongIndex ==
                                  index
                              ? LottieBuilder.asset(
                                  "assets/lotties/default_music.json",
                                  width: 20,
                                  animate: context.read<MusicCubit>().isPlaying,
                                )
                              : const SizedBox(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          visibility(
            context: context,
            tapToBottomSheet: () async {
              await bottomsheet(
                musicDuration: musicDuraition,
                context: context,
                nameSongs: _nameSongs,
                player: player,
              );
            },
            tapToPlay: () async {
              context.read<MusicCubit>().isPlaying =
                  !context.read<MusicCubit>().isPlaying;
              context.read<MusicCubit>().isPlaying
                  ? await player.resume()
                  : await player.pause();

              setState(() {});
            },
            player: player,
          ),
        ],
      ),
    );
  }

  void init() async {
    await Future.delayed(const Duration(seconds: 2), () {
      FlutterNativeSplash.remove();
    });

    getPemission();
    getMusicsFromStorage(directory: '/storage/emulated/0/Music/');
    getMusicsFromStorage(directory: '/storage/emulated/0/Download/');

    for (var i = 0; i < _songs.length; i++) {
      for (var j = _songs[i].path.length - 1; j >= 0; j--) {
        if (_songs[i].path[j] == "/") {
          context.read<MusicCubit>().slashIndexOfName = j;
          break;
        }
      }
      _nameSongs.add(_songs[i].path.substring(
          context.read<MusicCubit>().slashIndexOfName + 1,
          _songs[i].path.length));
    }
    setState(() {});
    if (_songs.isNotEmpty) {
      await GetStorage().write("favorites", _songs);
    }
  }

  void getMusicsFromStorage({required String directory}) {
    dir = Directory(directory);
    _files = dir.listSync(recursive: true, followLinks: false);
    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      if (path.endsWith('.mp3')) _songs.add(entity);
    }

    player.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed) {
        context.read<MusicCubit>().isPlaying = false;
        p.log("stop boldi");
        setState(() {});
      }
    });
  }
}
