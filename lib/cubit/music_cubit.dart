import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/data/shared_preferences.dart';

part 'music_state.dart';

class MusicCubit extends Cubit<MusicState> {
  MusicCubit() : super(MusicInitial());
  final player = AssetsAudioPlayer();
  bool isPlaying = false;
  bool isShowBottomSheet = false;
  int activeSongIndex = -1;
  int slashIndexOfName = -1;
  String activeSongName = "";
  List<FileSystemEntity> songs = [];
  List<String> nameSongs = [];
  List<FileSystemEntity> files = [];
  late Directory dir;
  bool isNext = false;
  bool isPlayingPlaylist = false;

  void bottomSheetClose() => emit(BottomSheetClosed());

  void changeToPlayOrPause() async {
    isPlaying = !isPlaying;
    isPlaying ? await player.play() : await player.pause();
  }

  void playMusic({required index}) {
    isPlaying = true;
    isShowBottomSheet = true;
    activeSongIndex = index;
    activeSongName = nameSongs[index].split("-")[0];
  }

  void getMusicsName() async {
    for (var i = 0; i < songs.length; i++) {
      for (var j = songs[i].path.length - 1; j >= 0; j--) {
        if (songs[i].path[j] == "/") {
          slashIndexOfName = j;
          break;
        }
      }
      nameSongs.add(
          songs[i].path.substring(slashIndexOfName + 1, songs[i].path.length));
    }
  }

  void getMusicsFromStorage({required String directory}) {
    dir = Directory(directory);
    files = dir.listSync(recursive: true, followLinks: false);
    for (FileSystemEntity entity in files) {
      String path = entity.path;
      if (path.endsWith('.mp3')) songs.add(entity);
    }
  }

  void changeToNextMusicWhenFinished() async {
    player.playlistAudioFinished.listen(
      (event) async {
        if (isNext && isPlayingPlaylist == false) {
          if (event.playlist.nextIndex != songs.length) {
            if (activeSongIndex + 1 == songs.length) {
              activeSongIndex = 0;
            } else if (activeSongIndex < songs.length - 1) {
              activeSongIndex = activeSongIndex + 1;
            }
            await player.stop();
            activeSongName = nameSongs[activeSongIndex].split("-")[0];
            await player.open(
              Audio.file(
                songs[activeSongIndex].path,
                metas: Metas(
                  title: activeSongName,
                  artist: nameSongs[activeSongIndex].split("-").length > 1
                      ? nameSongs[activeSongIndex].split("-")[1].substring(
                          1, nameSongs[activeSongIndex].split("-")[1].length)
                      : "Undifined",
                ),
              ),
              showNotification: true,
              notificationSettings: NotificationSettings(
                customNextAction: (player) async {
                  await player.stop();
                },
                customPrevAction: (player) async {
                  await player.stop();
                },
              ),
            );
            activeSongName = nameSongs[activeSongIndex].split("-")[0];
          }
        } else if (!isNext && isPlayingPlaylist == false) {
          changeToPreviousMusic();
        } else if (isPlayingPlaylist) {
          if (event.playlist.nextIndex != musicsInfavorites.length) {
            if (activeSongIndex + 1 == musicsInfavorites.length) {
              activeSongIndex = 0;
            } else if (activeSongIndex < musicsInfavorites.length - 1) {
              activeSongIndex = activeSongIndex + 1;
            }
            await player.stop();
            activeSongName = nameSongs[activeSongIndex].split("-")[0];
            await player.open(
              Audio.file(
                musicsInfavorites[activeSongIndex],
                metas: Metas(
                  title: activeSongName,
                  artist: nameSongs[activeSongIndex].split("-").length > 1
                      ? nameSongs[activeSongIndex].split("-")[1].substring(
                          1, nameSongs[activeSongIndex].split("-")[1].length)
                      : "Undifined",
                ),
              ),
              showNotification: true,
              notificationSettings: NotificationSettings(
                customNextAction: (player) async {
                  await player.stop();
                },
                customPrevAction: (player) async {
                  await player.stop();
                },
              ),
            );
            activeSongName = nameSongs[activeSongIndex].split("-")[0];
          }
        }
      },
    );
  }

  void changeToNextMusic() async {
    if (activeSongIndex + 1 == songs.length) {
      activeSongIndex = 0;
    } else if (activeSongIndex < songs.length - 1) {
      activeSongIndex = activeSongIndex + 1;
    }
    await player.open(
      Audio.file(
        songs[activeSongIndex].path,
        metas: Metas(
          title: activeSongName,
          artist: nameSongs[activeSongIndex].split("-").length > 1
              ? nameSongs[activeSongIndex]
                  .split("-")[1]
                  .substring(1, nameSongs[activeSongIndex].split("-")[1].length)
              : "Undifined",
          album: "CountryAlbum",
        ),
      ),
      showNotification: true,
      notificationSettings: NotificationSettings(
        customNextAction: (player) async {
          await player.stop();
        },
        customPrevAction: (player) async {
          await player.stop();
        },
      ),
    );
    activeSongName = nameSongs[activeSongIndex].split("-")[0];
  }

  void changeToPreviousMusic() async {
    var index = activeSongIndex;
    if (index > 0) index = activeSongIndex = activeSongIndex - 1;
    await player.open(
      Audio.file(
        songs[activeSongIndex].path,
        metas: Metas(
          title: activeSongName,
          artist: nameSongs[index].split("-").length > 1
              ? nameSongs[index]
                  .split("-")[1]
                  .substring(1, nameSongs[index].split("-")[1].length)
              : "Undifined",
          album: "CountryAlbum",
        ),
      ),
      showNotification: true,
    );
    activeSongName = nameSongs[index].split("-")[0];
  }

  //////////////////////////// PlayList Screen ///////////////////////////////////////

  List<String> musicsInfavorites = [];

  List<String> songsNameInPlayList = [];

  void readFromStorage() async {
    musicsInfavorites = StorageRepository.getList("favorites");
  }

  void getMusicsFromPlaylists() {
    for (var i = 0; i < musicsInfavorites.length; i++) {
      for (var j = musicsInfavorites[i].length - 1; j >= 0; j--) {
        if (musicsInfavorites[i][j] == "/") {
          slashIndexOfName = j;
          break;
        }
      }
    }
  }

  void addMusicsNameInPlaylist() async {
    List<String> musics = [];
    songsNameInPlayList = [];
    musics = StorageRepository.getList("favorites");
    for (var i = 0; i < musicsInfavorites.length; i++) {
      songsNameInPlayList
          .add(musics[i].substring(slashIndexOfName + 1, musics[i].length));
    }
    var set = songsNameInPlayList.toSet();
    songsNameInPlayList = set.toList();
  }

  void playMusicInPlayList({required index}) {
    isPlaying = true;
    isShowBottomSheet = true;
    activeSongIndex = index;
    activeSongName = songsNameInPlayList[index].split("-")[0];
  }

  void changeToPlayOrPausePlayList() async {
    isPlaying = !isPlaying;
    isPlaying ? player.play() : await player.pause();
  }
}
