// ignore_for_file: use_build_context_synchronously

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/cubit/music_cubit.dart';
import 'package:music_app/ui/home/widgets/bottom_sheet.dart';
import 'package:music_app/ui/home/widgets/on_long_press_dialog.dart';
import 'package:music_app/ui/home/widgets/playlists.dart';
import 'package:music_app/ui/home/widgets/visible_bottom_sheet.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/constants.dart';
import 'package:music_app/utils/text_style.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentMusicIndex = 0;
  late PermissionStatus permission;
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
      body: BlocListener<MusicCubit, MusicState>(
        listener: (context, state) {
          if (state is BottomSheetClosed) {
            setState(() {});
          }
        },
        child: Column(
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
                      itemCount: context.read<MusicCubit>().songs.length,
                      itemBuilder: (context, index) {
                        List<String> subtitle = context
                            .read<MusicCubit>()
                            .nameSongs[index]
                            .split("-");
                        return GestureDetector(
                          onTap: () async {
                            context.read<MusicCubit>().playMusic(index: index);
                            musicDuraition = (await context
                                .read<MusicCubit>()
                                .player
                                .getDuration())!;
                            currentMusicIndex = index;
                            currentPosition = (await context
                                .read<MusicCubit>()
                                .player
                                .getCurrentPosition())!;
                            await context.read<MusicCubit>().player.play(
                                DeviceFileSource(context
                                    .read<MusicCubit>()
                                    .songs[index]
                                    .path));
                            setState(() {});
                          },
                          onLongPress: () async {
                            onLongPressDialog(
                              context: context,
                              song:
                                  context.read<MusicCubit>().songs[index].path,
                              indexSelectedMusic: index,
                            );
                          },
                          child: ListTile(
                            title: Text(
                              context
                                  .read<MusicCubit>()
                                  .nameSongs[index]
                                  .split("-")[0]
                                  .toString(),
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
                                    animate:
                                        context.read<MusicCubit>().isPlaying,
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
                  nameSongs: context.read<MusicCubit>().nameSongs,
                  player: context.read<MusicCubit>().player,
                  currentPosition: currentPosition,
                  currentMusicIndex: currentMusicIndex,
                );
              },
              tapToPlay: () async {
                context.read<MusicCubit>().changeToPlayOrPause();
                setState(() {});
              },
              player: context.read<MusicCubit>().player,
            ),
          ],
        ),
      ),
    );
  }

  void init() async {
    permission = await Permission.storage.request();
    if (permission == PermissionStatus.granted) {
      FlutterNativeSplash.remove();
    }

    context
        .read<MusicCubit>()
        .getMusicsFromStorage(directory: '/storage/emulated/0/Music/');
    context
        .read<MusicCubit>()
        .getMusicsFromStorage(directory: '/storage/emulated/0/Download/');
    context.read<MusicCubit>().getMusicsName();
    setState(() {});
  }
}
