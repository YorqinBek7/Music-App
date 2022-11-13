import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/cubit/music_cubit.dart';
import 'package:music_app/ui/home/widgets/bottom_sheet.dart';
import 'package:music_app/ui/home/widgets/on_long_press_dialog.dart';
import 'package:music_app/ui/home/widgets/playlists.dart';
import 'package:music_app/ui/home/widgets/theme_button.dart';
import 'package:music_app/ui/home/widgets/visible_bottom_sheet.dart';
import 'package:music_app/utils/constants.dart';
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
    var cubitRead = context.read<MusicCubit>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Music App", style: Theme.of(context).textTheme.headline4),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      body: BlocListener<MusicCubit, MusicState>(
        listener: (context, state) {
          if (state is BottomSheetClosed) setState(() {});
        },
        child: Column(
          children: [
            const ThemeButton(),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 10),
                    Text("Your Playlist",
                        style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 10),
                    PlaylistContainers(
                      title: 'My favorites',
                      image: 'assets/images/favorite_playlist.png',
                      onTap: () {
                        cubitRead.isPlayingPlaylist = true;
                        Navigator.pushNamed(
                          context,
                          playlistScreen,
                          arguments: "My Favorites",
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Text("Songs", style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 5),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: cubitRead.songs.length,
                      itemBuilder: (context, index) {
                        List<String> subtitle =
                            cubitRead.nameSongs[index].split("-");
                        return GestureDetector(
                          onTap: () async {
                            cubitRead.playMusic(index: index);
                            currentMusicIndex = index;
                            await playMusic(context, cubitRead);
                            setState(() {});
                          },
                          onLongPress: () async {
                            onLongPressDialog(
                              context: context,
                              song: cubitRead.songs[index].path,
                              indexSelectedMusic: index,
                            );
                          },
                          child: ListTile(
                            title: Text(
                              cubitRead.nameSongs[index]
                                  .split("-")[0]
                                  .toString(),
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            subtitle: Text(
                              subtitle.length > 1
                                  ? subtitle[1].substring(1, subtitle[1].length)
                                  : "Undifined",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            trailing: cubitRead.activeSongIndex == index
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
                  nameSongs: cubitRead.nameSongs,
                  player: cubitRead.player,
                  currentPosition: currentPosition,
                  currentMusicIndex: currentMusicIndex,
                );
              },
              tapToPlay: () async {
                cubitRead.changeToPlayOrPause();

                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> playMusic(BuildContext context, MusicCubit cubitRead) async {
    List<Audio> audios = [];
    for (var element in context.read<MusicCubit>().songs) {
      audios.add(Audio.file(element.path));
    }
    await context.read<MusicCubit>().player.open(
          Playlist(audios: audios),
          showNotification: true,
          autoStart: false,
        );
    cubitRead.activeSongName =
        cubitRead.nameSongs[cubitRead.activeSongIndex].split("-")[0];
    await cubitRead.player.playlistPlayAtIndex(currentMusicIndex);
  }

  void init() async {
    permission = await Permission.storage.request();
    if (permission == PermissionStatus.granted) FlutterNativeSplash.remove();
    context
        .read<MusicCubit>()
        .getMusicsFromStorage(directory: '/storage/emulated/0/Music/');
    context
        .read<MusicCubit>()
        .getMusicsFromStorage(directory: '/storage/emulated/0/Download/');
    context.read<MusicCubit>().getMusicsName();
    context.read<MusicCubit>().changeToNextMusicWhenFinished();
    setState(() {});
  }
}
