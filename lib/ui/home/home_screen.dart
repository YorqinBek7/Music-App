import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/cubit/music_cubit.dart';
import 'package:music_app/ui/home/widgets/bottom_sheet.dart';
import 'package:music_app/ui/home/widgets/on_long_press_dialog.dart';
import 'package:music_app/ui/home/widgets/play.dart';
import 'package:music_app/ui/home/widgets/theme_button.dart';
import 'package:music_app/ui/home/widgets/visible_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late PermissionStatus permission;
  Duration musicDuraition = const Duration();
  Duration currentPosition = const Duration();
  late TabController controller;
  late TabController tabController;

  @override
  void initState() {
    init();
    controller = TabController(length: 2, vsync: this);
    tabController = TabController(length: 2, vsync: this);

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
        title: Text("Melody App", style: Theme.of(context).textTheme.headline4),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      body: BlocListener<MusicCubit, MusicState>(
        listener: (context, state) {
          if (state is BottomSheetClosedState) setState(() {});
        },
        child: Column(
          children: [
            const ThemeButton(),
            const SizedBox(height: 20),
            TabBar(
              controller: tabController,
              onTap: (value) => {
                if (mounted)
                  {
                    setState(
                      () => {
                        controller.index = value,
                      },
                    )
                  }
              },
              tabs: [
                Text(
                  "All Songs",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontSize: 25),
                ),
                Text(
                  "Favorites",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontSize: 25),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                children: [
                  // All Songs
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const SizedBox(height: 20),
                        Text("Songs",
                            style: Theme.of(context).textTheme.headline4),
                        const SizedBox(height: 5),
                        cubitRead.songs.isEmpty
                            ? LottieBuilder.asset("assets/lotties/nodata.json")
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: cubitRead.songs.length,
                                itemBuilder: (context, index) {
                                  List<String> subtitle =
                                      cubitRead.nameSongs[index].split("-");
                                  return GestureDetector(
                                    onTap: () async {
                                      cubitRead.listenMusicFinish((fn) {
                                        setState(() {});
                                      });
                                      cubitRead.isPlayingFromPlaylist = false;
                                      await playMusic(
                                        context: context,
                                        cubitRead: cubitRead,
                                        isPlayingFromPlaylist: false,
                                        songsName: cubitRead.nameSongs,
                                        songs: cubitRead.songs,
                                        index: index,
                                        setter: (void Function() fn) {
                                          setState(() {});
                                        },
                                      );
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      subtitle: Text(
                                        subtitle.length > 1
                                            ? subtitle[1].substring(
                                                1, subtitle[1].length)
                                            : "Undifined",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      trailing: cubitRead.activeSongIndex ==
                                              index
                                          ? LottieBuilder.asset(
                                              "assets/lotties/default_music.json",
                                              width: 20,
                                              animate: context
                                                  .read<MusicCubit>()
                                                  .isPlaying)
                                          : const SizedBox(),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                  // Playlist
                  Column(
                    children: [
                      Expanded(
                        child: cubitRead.songsNameInPlayList.isEmpty
                            ? LottieBuilder.asset("assets/lotties/nodata.json")
                            : ListView.builder(
                                itemCount: cubitRead.songsNameInPlayList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      cubitRead.listenMusicFinish((fn) {
                                        setState(() {});
                                      });

                                      cubitRead.isPlayingFromPlaylist = true;
                                      await playMusic(
                                        context: context,
                                        cubitRead: cubitRead,
                                        isPlayingFromPlaylist: true,
                                        songs: cubitRead.musicsInfavorites,
                                        songsName:
                                            cubitRead.songsNameInPlayList,
                                        index: index,
                                        setter: (void Function() fn) {},
                                      );
                                      setState(() {});
                                    },
                                    child: ListTile(
                                      title: Text(
                                        cubitRead.songsNameInPlayList[index]
                                            .split("-")[0]
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      subtitle: Text(
                                        cubitRead.songsNameInPlayList[index]
                                                    .split("-")
                                                    .length >
                                                1
                                            ? cubitRead
                                                .songsNameInPlayList[index]
                                                .split("-")[1]
                                            : "Undifined",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            ?.copyWith(fontSize: 14),
                                      ),
                                      trailing:
                                          cubitRead.activePlaylistSongIndex ==
                                                  index
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
                    ],
                  )
                ],
              ),
            ),
            visibility(
              context: context,
              tapToBottomSheet: () async {
                await bottomsheet(
                  context: context,
                  nameSongs: cubitRead.isPlayingFromPlaylist
                      ? cubitRead.songsNameInPlayList
                      : cubitRead.nameSongs,
                  player: cubitRead.player,
                  musicDuration: musicDuraition,
                  currentPosition: currentPosition,
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

    context.read<MusicCubit>().readFromStorage();
    context.read<MusicCubit>().getMusicsFromPlaylists();
    context.read<MusicCubit>().addMusicsNameInPlaylist();
    context.read<MusicCubit>().whenAllSongsEnded((fn) {
      setState(() {});
    });
    setState(() {});
  }
}
