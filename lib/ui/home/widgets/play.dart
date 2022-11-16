import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/cubit/music_cubit.dart';

Future<void> playMusic(
    {required BuildContext context,
    required MusicCubit cubitRead,
    required bool isPlayingFromPlaylist,
    required List<dynamic> songs,
    required List<String> songsName,
    required int index,
    required StateSetter setter}) async {
  cubitRead.isPlayingFromPlaylist = isPlayingFromPlaylist;
  cubitRead.playMusic(index: index);
  List<Audio> audios = [];
  for (var element in songs) {
    audios.add(
      Audio.file(
        !isPlayingFromPlaylist ? element.path : element,
        metas: Metas(
          title: cubitRead.activeSongName,
        ),
      ),
    );
  }

  await context.read<MusicCubit>().player.open(
        Playlist(audios: audios),
        showNotification: true,
        autoStart: false,
        notificationSettings: NotificationSettings(
          customNextAction: (player) {
            if (cubitRead.isPlayingFromPlaylist) {
              if (cubitRead.activePlaylistSongIndex <
                  cubitRead.songsNameInPlayList.length) {
                cubitRead.activePlaylistSongIndex++;
                cubitRead.activeSongName = cubitRead
                    .songsNameInPlayList[cubitRead.activePlaylistSongIndex];
              }
              cubitRead.player.updateCurrentAudioNotification(
                metas: Metas(
                  title: cubitRead.activeSongName,
                ),
              );
            } else {
              if (cubitRead.activeSongIndex < cubitRead.nameSongs.length) {
                cubitRead.activeSongIndex++;
                cubitRead.activeSongName =
                    cubitRead.nameSongs[cubitRead.activeSongIndex];
              }
              cubitRead.player.updateCurrentAudioNotification(
                metas: Metas(
                  title: cubitRead.activeSongName,
                ),
              );
            }
            player.next();
            setter(
              () => {},
            );
          },
          customPrevAction: (player) {
            if (cubitRead.isPlayingFromPlaylist) {
              if (cubitRead.activePlaylistSongIndex > 0) {
                cubitRead.activePlaylistSongIndex--;
                cubitRead.activeSongName = cubitRead
                    .songsNameInPlayList[cubitRead.activePlaylistSongIndex];
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
            player.previous();
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
