// ignore_for_file: use_build_context_synchronously
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/cubit/music_cubit.dart';
import 'package:music_app/data/shared_preferences.dart';
import 'package:music_app/ui/home/widgets/bottom_sheet.dart';
import 'package:music_app/ui/home/widgets/visible_bottom_sheet.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/text_style.dart';

class PlaylistScreen extends StatefulWidget {
  final String namePlaylist;

  const PlaylistScreen({super.key, required this.namePlaylist});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  int currentMusicIndex = 0;
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
      backgroundColor: MusicAppColor.C_0F0F1D,
      body: SafeArea(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: MusicAppColor.white,
                      ),
                      onPressed: () => {
                        Navigator.pop(context),
                      },
                    ),
                    const Spacer(),
                    Image.asset(
                      "assets/images/favorite_playlist.png",
                      width: 60,
                    ),
                    Text(
                      widget.namePlaylist,
                      style: MusicAppTextStyle.w500,
                    ),
                    const Spacer(),
                  ],
                )),
            Expanded(
                child: ListView.builder(
                    itemCount:
                        context.read<MusicCubit>().songsNameInPlayList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          currentMusicIndex = index;
                          context
                              .read<MusicCubit>()
                              .playMusicInPlayList(index: index);
                          await context.read<MusicCubit>().player.play(
                              DeviceFileSource(context
                                  .read<MusicCubit>()
                                  .songsNameInPlayList[index]));
                          musicDuraition = (await context
                              .read<MusicCubit>()
                              .player
                              .getDuration())!;
                          currentPosition = (await context
                              .read<MusicCubit>()
                              .player
                              .getCurrentPosition())!;
                          setState(() {});
                        },
                        child: ListTile(
                          title: Text(
                            context
                                .read<MusicCubit>()
                                .songsNameInPlayList[index]
                                .split("-")[0]
                                .toString(),
                            style: MusicAppTextStyle.w500
                                .copyWith(color: MusicAppColor.white),
                          ),
                          subtitle: Text(
                            context
                                        .read<MusicCubit>()
                                        .songsNameInPlayList[index]
                                        .split("-")
                                        .length >
                                    1
                                ? context
                                    .read<MusicCubit>()
                                    .songsNameInPlayList[index]
                                    .split("-")[1]
                                : "Undifined",
                            style: MusicAppTextStyle.w500
                                .copyWith(color: MusicAppColor.grey),
                          ),
                          trailing:
                              context.watch<MusicCubit>().activeSongIndex ==
                                      index
                                  ? LottieBuilder.asset(
                                      "assets/lotties/default_music.json",
                                      width: 30,
                                    )
                                  : const SizedBox(),
                        ),
                      );
                    })),
            visibility(
              context: context,
              tapToBottomSheet: () async {
                await bottomsheet(
                  musicDuration: musicDuraition,
                  context: context,
                  nameSongs: context.read<MusicCubit>().songsNameInPlayList,
                  player: context.read<MusicCubit>().player,
                  currentPosition: currentPosition,
                  currentMusicIndex: 0,
                );
              },
              tapToPlay: () async {
                context.read<MusicCubit>().changeToPlayOrPausePlayList();
                setState(() {});
              },
              player: context.read<MusicCubit>().player,
            ),
          ],
        ),
      ),
    );
  }

  init() async {
    await StorageRepository.getInstance();
    context.read<MusicCubit>().readFromStorage();
    context.read<MusicCubit>().getMusicsFromPlaylists();
    context.read<MusicCubit>().addMusicsNameInPlaylist();
    context.read<MusicCubit>().musicsInPlaylist =
        StorageRepository.getList("favorites");

    setState(() {});
  }
}
