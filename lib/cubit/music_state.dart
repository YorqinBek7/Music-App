part of 'music_cubit.dart';

@immutable
abstract class MusicState {}

class MusicInitial extends MusicState {}

class MusicPause extends MusicState {}

class MusicPlay extends MusicState {}

class MusicStop extends MusicState {}
