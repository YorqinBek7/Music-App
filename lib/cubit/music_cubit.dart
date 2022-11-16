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
  bool isPlayingFromPlaylist = false;
  int activeSongIndex = -1;
  int activePlaylistSongIndex = -1;
  int slashIndexOfName = -1;
  String activeSongName = "";
  List<FileSystemEntity> songs = [];
  List<String> nameSongs = [];
  List<FileSystemEntity> files = [];
  late Directory dir;

  void bottomSheetClose() => emit(BottomSheetClosedState());

  void changeToPlayOrPause() async {
    isPlaying = !isPlaying;
    isPlaying ? await player.play() : await player.pause();
  }

  void playMusic({required index}) {
    isPlaying = true;
    isShowBottomSheet = true;
    isPlayingFromPlaylist
        ? activePlaylistSongIndex = index
        : activeSongIndex = index;
    activeSongName = nameSongs[index];
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
    activeSongName = songsNameInPlayList[index];
  }

  void changeToPlayOrPausePlayList() async {
    isPlaying = !isPlaying;
    isPlaying ? player.play() : await player.pause();
  }
}
