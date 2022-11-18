import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/cubit/music_cubit.dart';

int k = 0;
Future<void> playMusic(
    {required BuildContext context,
    required MusicCubit cubitRead,
    required bool isPlayingFromPlaylist,
    required List<dynamic> songs,
    required List<String> songsName,
    required int index,
    required StateSetter setter}) async {
  cubitRead.playMusic(index: index);
  List<Audio> audios = [];
  for (var element in songs) {
    audios.add(
      Audio.file(
        !cubitRead.isPlayingFromPlaylist ? element.path : element,
        metas: Metas(
          title: cubitRead.activeSongName,
          image: const MetasImage(
            path: "assets/images/app_icon.png",
            type: ImageType.asset,
          ),
        ),
      ),
    );
  }

  await context.read<MusicCubit>().player.open(
        Playlist(audios: audios),
        showNotification: true,
        autoStart: false,
        notificationSettings: NotificationSettings(
          customPlayPauseAction: (player) => {
            cubitRead.changeToPlayOrPause(),
            setter(
              () => {},
            )
          },
          customNextAction: (player) async {
            await cubitRead.player.next();
          },
          customPrevAction: (player) async {
            if (cubitRead.isPlayingFromPlaylist) {
              if (cubitRead.activePlaylistSongIndex > 0) {
                cubitRead.activePlaylistSongIndex--;
                cubitRead.activeSongName = cubitRead
                    .songsNameInPlayList[cubitRead.activePlaylistSongIndex];
                await player.updateCurrentAudioNotification(
                  metas: Metas(
                    title: cubitRead.activeSongName,
                    image: const MetasImage(
                      path: "assets/images/app_icon.png",
                      type: ImageType.asset,
                    ),
                  ),
                );
              }
            } else {
              if (cubitRead.activeSongIndex > 0) {
                cubitRead.activeSongIndex--;
                cubitRead.activeSongName =
                    cubitRead.nameSongs[cubitRead.activeSongIndex];
                cubitRead.player.updateCurrentAudioNotification(
                  metas: Metas(
                    title: cubitRead.activeSongName,
                    image: const MetasImage(
                      path: "assets/images/app_icon.png",
                      type: ImageType.asset,
                    ),
                  ),
                );
              }
            }
            await cubitRead.player.previous();
            setter(
              () => {},
            );
          },
        ),
      );
  cubitRead.activeSongName = songsName[cubitRead.isPlayingFromPlaylist
      ? cubitRead.activePlaylistSongIndex
      : cubitRead.activeSongIndex < cubitRead.nameSongs.length
          ? cubitRead.activeSongIndex
          : 0];
  await cubitRead.player.playlistPlayAtIndex(index);
}
