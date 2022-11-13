import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/cubit/music_cubit.dart';
import 'package:music_app/ui/home/widgets/bottom_sheet.dart';
import 'package:music_app/ui/home/widgets/visible_bottom_sheet.dart';

class PlaylistScreen extends StatefulWidget {
  final String namePlaylist;
  const PlaylistScreen({super.key, required this.namePlaylist});
  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  Duration musicDuraition = const Duration();
  Duration currentPosition = const Duration();
  int currentMusicIndex = -1;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubitRead = context.read<MusicCubit>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        color: Theme.of(context).buttonColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Image.asset(
                    "assets/images/favorite_playlist.png",
                    width: 60,
                  ),
                  Text(
                    widget.namePlaylist,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount:
                    context.read<MusicCubit>().songsNameInPlayList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      cubitRead.player.stop();
                      currentMusicIndex = index;
                      List<Audio> audios = [];
                      for (var element in cubitRead.musicsInfavorites) {
                        audios.add(Audio.file(element));
                      }
                      await context.read<MusicCubit>().player.open(
                            Playlist(audios: audios),
                            showNotification: true,
                            autoStart: false,
                          );
                      cubitRead.activeSongName =
                          cubitRead.songsNameInPlayList[index].split("-")[0];
                      await cubitRead.player.playlistPlayAtIndex(index);
                      cubitRead.isShowBottomSheet = true;
                      cubitRead.isPlaying = true;
                      setState(() {});
                    },
                    child: ListTile(
                      title: Text(
                        cubitRead.songsNameInPlayList[index]
                            .split("-")[0]
                            .toString(),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      subtitle: Text(
                        cubitRead.songsNameInPlayList[index].split("-").length >
                                1
                            ? cubitRead.songsNameInPlayList[index].split("-")[1]
                            : "Undifined",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontSize: 14),
                      ),
                      trailing: cubitRead.activeSongIndex == index
                          ? LottieBuilder.asset(
                              "assets/lotties/default_music.json",
                              width: 30,
                            )
                          : const SizedBox(),
                    ),
                  );
                },
              ),
            ),
            visibility(
              context: context,
              tapToBottomSheet: () async {
                await bottomsheet(
                  musicDuration: musicDuraition,
                  context: context,
                  nameSongs: cubitRead.songsNameInPlayList,
                  player: cubitRead.player,
                  currentPosition: currentPosition,
                  currentMusicIndex: currentMusicIndex,
                );
              },
              tapToPlay: () async {
                cubitRead.changeToPlayOrPausePlayList();
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  init() async {
    context.read<MusicCubit>().readFromStorage();
    context.read<MusicCubit>().getMusicsFromPlaylists();
    context.read<MusicCubit>().addMusicsNameInPlaylist();
    setState(() {});
  }
}
