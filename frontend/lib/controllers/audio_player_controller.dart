import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerController extends StateNotifier<AudioPlayer> {
  AudioPlayerController() : super(AudioPlayer());

  Future<void> playAudio(String url) async {
    await state.setUrl(url);
    await state.play();
  }

  void pauseAudio() {
    state.pause();
  }

  void stopAudio() {
    state.stop();
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }
}

final audioPlayerControllerProvider =
    StateNotifierProvider<AudioPlayerController, AudioPlayer>((ref) {
  return AudioPlayerController();
});
