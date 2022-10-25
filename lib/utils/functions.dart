import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer' as print;

void getMusicFromStorage(
    {required List<FileSystemEntity> songs,
    required List<FileSystemEntity> files,
    required String nameOfReversed,
    required String nameOfSong,
    required List<String> listSongs,
    required ValueChanged setState}) {
  for (FileSystemEntity entity in songs) {
    String path = entity.path;
    if (path.endsWith('.mp3')) {
      songs.add(entity);
    }
  }
  for (int i = 0; i < songs.length; i++) {
    nameOfReversed = "";
    nameOfSong = "";
    for (var j = songs[i].path.length - 1; j >= 0; j--) {
      if (songs[i].path[j] == "/") {
        break;
      } else {
        nameOfReversed += songs[i].path[j];
      }
    }
    for (int j = nameOfReversed.length - 1; j >= 0; j--) {
      nameOfSong += nameOfReversed[j];
    }
    listSongs.add(nameOfSong);
  }
  // print.log(nameOfSong.toString());
  setState(() {});
}
