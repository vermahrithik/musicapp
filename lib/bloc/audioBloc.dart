import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/bloc/audioEvent.dart';
import 'package:musicapp/bloc/audioState.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioBloc() : super(AudioInitial()) {
    on<LoadAudio>(_onLoadAudio);
    on<PlayAudio>(_onPlayAudio);
    on<PauseAudio>(_onPauseAudio);
    on<StopAudio>(_onStopAudio);
  }

  Future<void> _onLoadAudio(LoadAudio event, Emitter<AudioState> emit) async {
    emit(AudioLoading());
    try {
      await _audioPlayer.setUrl(event.url);
      emit(AudioStopped());
    } catch (e) {
      emit(AudioError(message: "Failed to load audio: ${e.toString()}"));
    }
  }

  Future<void> _onPlayAudio(PlayAudio event, Emitter<AudioState> emit) async {
    try {
      await _audioPlayer.play();
      emit(AudioPlaying());
    } catch (e) {
      emit(AudioError(message: "Failed to play audio: ${e.toString()}"));
    }
  }

  Future<void> _onPauseAudio(PauseAudio event, Emitter<AudioState> emit) async {
    try {
      await _audioPlayer.pause();
      emit(AudioPaused());
    } catch (e) {
      emit(AudioError(message: "Failed to pause audio: ${e.toString()}"));
    }
  }

  Future<void> _onStopAudio(StopAudio event, Emitter<AudioState> emit) async {
    try {
      await _audioPlayer.stop();
      emit(AudioStopped());
    } catch (e) {
      emit(AudioError(message: "Failed to stop audio: ${e.toString()}"));
    }
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
