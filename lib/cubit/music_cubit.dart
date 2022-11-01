import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'music_state.dart';

class MusicCubit extends Cubit<MusicState> {
  MusicCubit() : super(MusicInitial());

  bool isPlaying = false;
  bool isShowBottomSheet = false;
  int activeSongIndex = -1;
  int slashIndexOfName = -1;
  String activeSongName = "";
}
