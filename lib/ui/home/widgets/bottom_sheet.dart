import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:music_app/cubit/music_cubit.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/text_style.dart';

bottomsheet({
  required BuildContext context,
  required List<String> nameSongs,
  required AssetsAudioPlayer player,
  required Duration musicDuration,
  required Duration currentPosition,
  isClosed = false,
}) async {
  showMaterialModalBottomSheet(
    backgroundColor: MusicAppColor.C_536987,
    context: context,
    builder: (context) {
      var cubitRead = context.read<MusicCubit>();
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          player.currentPosition.listen(
            (position) => {
              currentPosition = position,
              if (!isClosed) setState(() => {}),
            },
          );
          player.current.listen(
            (data) => musicDuration =
                data?.audio.duration ?? const Duration(seconds: 0),
          );

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: LottieBuilder.asset(
                  "assets/lotties/default_music.json",
                  animate: cubitRead.isPlaying,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: cubitRead.isPlayingFromPlaylist
                    ? Text(
                        cubitRead.songsNameInPlayList[
                            cubitRead.activePlaylistSongIndex <
                                    cubitRead.songsNameInPlayList.length
                                ? cubitRead.activePlaylistSongIndex
                                : 0],
                        style: MusicAppTextStyle.w500,
                      )
                    : Text(
                        nameSongs[cubitRead.activeSongIndex <
                                cubitRead.nameSongs.length
                            ? cubitRead.activeSongIndex
                            : 0],
                        style: MusicAppTextStyle.w500,
                      ),
              ),
              Slider(
                  max: musicDuration.inSeconds.toDouble(),
                  onChanged: (double value) {
                    player.seek(Duration(seconds: value.toInt()));
                    player.play();
                    currentPosition = Duration(seconds: value.toInt());
                    setState(() => {});
                  },
                  value: currentPosition.inSeconds.toDouble()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: MusicAppColor.white, shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: () async {
                        player.previous();
                        cubitRead.isPlaying = true;
                        if (cubitRead.isPlayingFromPlaylist) {
                          if (cubitRead.activePlaylistSongIndex > 0) {
                            cubitRead.activePlaylistSongIndex--;
                            cubitRead.activeSongName =
                                cubitRead.songsNameInPlayList[
                                    cubitRead.activePlaylistSongIndex];
                          }
                          cubitRead.player.updateCurrentAudioNotification(
                            metas: Metas(
                              title: cubitRead.activeSongName,
                            ),
                          );
                        } else {
                          if (cubitRead.activeSongIndex > 0) {
                            cubitRead.activeSongIndex--;
                            cubitRead.activeSongName =
                                cubitRead.nameSongs[cubitRead.activeSongIndex];
                          }
                          cubitRead.player.updateCurrentAudioNotification(
                            metas: Metas(
                              title: cubitRead.activeSongName,
                            ),
                          );
                        }
                        setState(() => {});
                      },
                      icon: const Icon(Icons.skip_previous, size: 25),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: MusicAppColor.white, shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: () async {
                        cubitRead.changeToPlayOrPause();
                        cubitRead.isPlaying
                            ? await player.play()
                            : await player.pause();
                        setState(() => {});
                      },
                      icon: Icon(
                        context.watch<MusicCubit>().isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 30,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: MusicAppColor.white, shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: () async {
                        await player.next();
                        cubitRead.isPlaying = true;
                        if (cubitRead.isPlayingFromPlaylist) {
                          if (cubitRead.activePlaylistSongIndex <
                              cubitRead.songsNameInPlayList.length) {
                            cubitRead.activePlaylistSongIndex++;
                            cubitRead.activeSongName =
                                cubitRead.songsNameInPlayList[
                                    cubitRead.activePlaylistSongIndex];
                          }
                          cubitRead.player.updateCurrentAudioNotification(
                            metas: Metas(
                              title: cubitRead.activeSongName,
                            ),
                          );
                        } else {
                          if (cubitRead.activeSongIndex < nameSongs.length) {
                            cubitRead.activeSongIndex++;
                            cubitRead.activeSongName =
                                nameSongs[cubitRead.activeSongIndex];
                          }
                          cubitRead.player.updateCurrentAudioNotification(
                            metas: Metas(
                              title: cubitRead.activeSongName,
                            ),
                          );
                        }

                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.skip_next,
                        size: 25,
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        },
      );
    },
  ).whenComplete(() {
    isClosed = true;
    context.read<MusicCubit>().bottomSheetClose();
  });
}
