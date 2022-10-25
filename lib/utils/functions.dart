import 'dart:io';

void getMusicFromStorage({
  required songs,
  required files,
  required String nameOfReversed,
  required String nameOfSongs,
  required List<String> listSongs,
}) {
  for (FileSystemEntity entity in _files) {
    String path = entity.path;
    if (path.endsWith('.mp3')) {
      songs.add(entity);
    }
  }
  for (int i = 0; i < songs.length; i++) {
    name = "";
    name2 = "";
    for (var j = songs[i].path.length - 1; j >= 0; j--) {
      if (songs[i].path[j] == "/") {
        break;
      } else {
        name += songs[i].path[j];
      }
    }
    for (int j = name.length - 1; j >= 0; j--) {
      name2 += name[j];
    }
    nameOfSongs.add(name2);
  }
  print.log(nameOfSongs.toString());
  setState(() {});
}
