import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/data/shared_preferences.dart';

part 'music_state.dart';

class MusicCubit extends Cubit<MusicState> {
  MusicCubit() : super(MusicInitial());

  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  bool isShowBottomSheet = false;
  int activeSongIndex = -1;
  int slashIndexOfName = -1;
  String activeSongName = "";
  List<FileSystemEntity> songs = [];
  List<String> nameSongs = [];
  List<FileSystemEntity> files = [];
  int whichPlaylist = -1;
  late Directory dir;

  void bottomSheetClose() => emit(BottomSheetClosed());

  void changeToPlayOrPause() async {
    isPlaying = !isPlaying;
    isPlaying ? await player.resume() : await player.pause();
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
    player.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed) {
        isPlaying = false;
      }
    });
  }

  void changeToNextMusic() async {
    if (activeSongIndex + 1 == songs.length) {
      activeSongIndex = 0;
    } else if (activeSongIndex < songs.length - 1) {
      activeSongIndex = activeSongIndex + 1;
    }
    await player.stop();
    await player.play(DeviceFileSource(songs[activeSongIndex].path));
    activeSongName = nameSongs[activeSongIndex].split("-")[0];
  }

  void changeToPreviousMusic() async {
    var index = activeSongIndex;
    if (index > 0) index = activeSongIndex = activeSongIndex - 1;
    await player.stop();
    await player.play(DeviceFileSource(songs[index].path));
    activeSongName = nameSongs[index].split("-")[0];
  }

  //////////////////////////// PlayList Screen ///////////////////////////////////////

  List<String> musicsInfavorites = [];
  List<String> musicsInOtherSongs = [];
  List<String> songsNameInPlayList = [];

  void readFromStorage() async {
    musicsInfavorites = whichPlaylist == 0
        ? StorageRepository.getList("favorites")
        : StorageRepository.getList("songs");
  }

  void getMusicsFromPlaylists() {
    if (whichPlaylist == 0) {
      for (var i = 0; i < musicsInfavorites.length; i++) {
        for (var j = musicsInfavorites[i].length - 1; j >= 0; j--) {
          if (musicsInfavorites[i][j] == "/") {
            slashIndexOfName = j;
            break;
          }
        }
      }
    } else if (whichPlaylist == 1) {
      for (var i = 0; i < musicsInOtherSongs.length; i++) {
        for (var j = musicsInOtherSongs[i].length - 1; j >= 0; j--) {
          if (musicsInOtherSongs[i][j] == "/") {
            slashIndexOfName = j;
            break;
          }
        }
      }
    }
  }

  void addMusicsNameInPlaylist() async {
    if (whichPlaylist == 0) {
      List<String> musics = [];
      songsNameInPlayList = [];
      musics = StorageRepository.getList("favorites");
      for (var i = 0; i < musicsInfavorites.length; i++) {
        songsNameInPlayList
            .add(musics[i].substring(slashIndexOfName + 1, musics[i].length));
      }
      var set = songsNameInPlayList.toSet();
      songsNameInPlayList = set.toList();
    } else if (whichPlaylist == 1) {
      List<String> musics = [];
      songsNameInPlayList = [];
      musics = StorageRepository.getList("songs");
      for (var i = 0; i < musicsInOtherSongs.length; i++) {
        songsNameInPlayList
            .add(musics[i].substring(slashIndexOfName + 1, musics[i].length));
      }
      var set = songsNameInPlayList.toSet();
      songsNameInPlayList = set.toList();
    }
  }

  void playMusicInPlayList({required index}) {
    isPlaying = true;
    isShowBottomSheet = true;
    activeSongIndex = index;
    activeSongName = songsNameInPlayList[index].split("-")[0];
  }

  void changeToPlayOrPausePlayList() async {
    isPlaying = !isPlaying;
    isPlaying ? await player.resume() : await player.pause();
  }
}
