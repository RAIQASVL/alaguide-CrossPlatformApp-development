import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:frontend/models/alaguide_object_model.dart';
import 'package:frontend/providers/audio_url_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AudioPlayerWidget extends ConsumerStatefulWidget {
  final AlaguideObject object;

  const AudioPlayerWidget({Key? key, required this.object}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends ConsumerState<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  String? _error;
  String? _currentLanguage;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    final audioInfo = ref.read(audioInfoProvider(widget.object));
    final availableLanguages = audioInfo.audioUrls.entries
        .where((entry) => entry.value != null)
        .map((entry) => entry.key)
        .toList();

    if (availableLanguages.isNotEmpty) {
      if (availableLanguages.contains(audioInfo.currentLanguage)) {
        _currentLanguage = audioInfo.currentLanguage;
      } else {
        _currentLanguage = availableLanguages.first;
      }
      await _loadAudio(_currentLanguage!);
    } else {
      setState(() {
        _error = 'No audio available for this content';
      });
    }
  }

  Future<void> _loadAudio(String language) async {
    try {
      final audioInfo = ref.read(audioInfoProvider(widget.object));
      final audioUrl = audioInfo.audioUrls[language];
      if (audioUrl != null) {
        print('Loading audio from: $audioUrl');
        await _audioPlayer.setUrl(audioUrl);

        _audioPlayer.playerStateStream.listen((state) {
          if (mounted) {
            setState(() {
              _isPlaying = state.playing;
            });
          }
        });
        setState(() {
          _error = null;
        });
      } else {
        setState(() {
          _error = 'No audio available for the selected language';
        });
      }
    } catch (e) {
      print('Error loading audio: $e');
      setState(() {
        _error = 'Error loading audio. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioInfo = ref.watch(audioInfoProvider(widget.object));
    final availableLanguages = audioInfo.audioUrls.entries
        .where((entry) => entry.value != null)
        .map((entry) => entry.key)
        .toList();

    return Column(
      children: [
        if (_currentLanguage != audioInfo.currentLanguage)
          Text(
            AppLocalizations.of(context)!.audioNotAvailableInCurrentLanguage,
            style: TextStyle(color: Color(0xFF5AD1E5)),
          ),
        DropdownButton<String>(
          value: _currentLanguage,
          items: availableLanguages
              .map((lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(getLanguageName(lang)),
                  ))
              .toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _currentLanguage = newValue;
              });
              _loadAudio(newValue);
            }
          },
        ),
        if (_error != null)
          Text(_error!, style: TextStyle(color: Colors.red))
        else
          Column(
            children: [
              StreamBuilder<Duration>(
                stream: _audioPlayer.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration = _audioPlayer.duration ?? Duration.zero;
                  return Column(
                    children: [
                      Slider(
                        value: position.inSeconds.toDouble(),
                        max: duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          _audioPlayer.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(position)),
                            Text(_formatDuration(duration)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () {
                      if (_isPlaying) {
                        _audioPlayer.pause();
                      } else {
                        _audioPlayer.play();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: () {
                      _audioPlayer.stop();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.replay_10),
                    onPressed: () {
                      _audioPlayer.seek(Duration(
                          seconds: _audioPlayer.position.inSeconds - 10));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.forward_10),
                    onPressed: () {
                      _audioPlayer.seek(Duration(
                          seconds: _audioPlayer.position.inSeconds + 10));
                    },
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      case 'kk':
        return 'Қазақша';
      default:
        return languageCode;
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
