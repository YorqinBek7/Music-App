import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/cubit/music_cubit.dart';
import 'package:music_app/ui/home/widgets/bottom_sheet.dart';
import 'package:music_app/ui/home/widgets/on_long_press_dialog.dart';
import 'package:music_app/ui/home/widgets/visible_bottom_sheet.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/text_style.dart';
import 'dart:developer' as p;

class PlaylistScreen extends StatefulWidget {
  final String namePlaylist;

  const PlaylistScreen({super.key, required this.namePlaylist});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer player = AudioPlayer();

  late Directory dir;
  List<FileSystemEntity> list = [];
  List<String> _nameSongs = [];

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
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          p.log(player.getDuration().toString());
                          await player.stop();

                          context.read<MusicCubit>().isPlaying = true;
                          context.read<MusicCubit>().isShowBottomSheet = true;

                          context.read<MusicCubit>().activeSongIndex = index;
                          context.read<MusicCubit>().activeSongName =
                              _nameSongs[index].split("-")[0];
                          await player.play(DeviceFileSource(await GetStorage()
                              .read("favorites")[index]
                              .path));
                          setState(() {});
                        },
                        onLongPress: () => {onLongPressDialog(context)},
                        child: ListTile(
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                  "assets/images/default_image.jpg")),
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
                  musicDuration: Duration(),
                  context: context,
                  nameSongs: _nameSongs,
                  player: player,
                );
              },
              tapToPlay: () async {
                context.read<MusicCubit>().isPlaying =
                    !context.read<MusicCubit>().isPlaying;
                context.watch<MusicCubit>().isPlaying
                    ? await player.resume()
                    : await player.pause();

                setState(() {});
              },
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
          context.read<MusicCubit>().slashIndexOfName = j;
          break;
        }
      }
    }
    for (var i = 0; i < list.length; i++) {
      _nameSongs.add(await GetStorage().read("favorites")[i].path.substring(
          context.read<MusicCubit>().slashIndexOfName + 1,
          await GetStorage().read("favorites")[i].path.length));
    }
    setState(() {});
  }
}
