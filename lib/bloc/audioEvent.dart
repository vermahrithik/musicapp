import 'package:equatable/equatable.dart';

abstract class AudioEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAudio extends AudioEvent {
  final String url;

  LoadAudio({required this.url});

  @override
  List<Object?> get props => [url];
}

class PlayAudio extends AudioEvent {}

class PauseAudio extends AudioEvent {}

class StopAudio extends AudioEvent {}
