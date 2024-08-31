import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/alaguide_object_model.dart';
import 'package:frontend/providers/language_provider.dart';

class AudioInfo {
  final Map<String, String?> audioUrls;
  final String currentLanguage;

  AudioInfo(this.audioUrls, this.currentLanguage);
}

final audioInfoProvider =
    Provider.family<AudioInfo, AlaguideObject>((ref, object) {
  final currentLanguage = ref.watch(languageProvider);

  Map<String, String?> audioUrls = {
    'ru': object.audio_rus_url,
    'en': object.audio_eng_url,
    'kk': object.audio_kz_url,
  };

  return AudioInfo(audioUrls, currentLanguage.languageCode);
});
