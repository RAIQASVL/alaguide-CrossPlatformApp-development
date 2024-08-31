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
  List<String> _availableLanguages = [];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    final audioInfo = ref.read(audioInfoProvider(widget.object));
    _availableLanguages = audioInfo.audioUrls.entries
        .where((entry) => entry.value != null)
        .map((entry) => entry.key)
        .toList();

    if (_availableLanguages.isNotEmpty) {
      if (_availableLanguages.contains(audioInfo.currentLanguage)) {
        _currentLanguage = audioInfo.currentLanguage;
      } else {
        _currentLanguage = _availableLanguages.first;
      }
      await _loadAudio(_currentLanguage!);
    } else {
      setState(() {
        _error =
            AppLocalizations.of(context)!.audioNotAvailableInCurrentLanguage;
      });
    }
  }

  // void _checkAudioAvailability() {
  //   final audioInfo = ref.read(audioInfoProvider(widget.object));
  //   final audioUrl = audioInfo.audioUrls[_currentLanguage];
  //   setState(() {
  //     _audioAvailable = audioUrl != null;
  //     if (!_audioAvailable) {
  //       _error =
  //           AppLocalizations.of(context)!.audioNotAvailableInCurrentLanguage;
  //     } else {
  //       _error = null;
  //       _loadAudio(_currentLanguage!);
  //     }
  //   });
  // }

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
          _audioPlayer.stop();
        });
      } else {
        setState(() {
          _error =
              AppLocalizations.of(context)!.audioNotAvailableInCurrentLanguage;
          _audioPlayer.stop();
        });
      }
    } catch (e) {
      print('Error loading audio: $e');
      setState(() {
        _error = AppLocalizations.of(context)!.errorLoadingAudio;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioInfo = ref.watch(audioInfoProvider(widget.object));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.object.author ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          widget.object.title ?? '',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Color(0xFF5AD1E5),
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        Text(
          '${AppLocalizations.of(context)!.readingGuide} ${widget.object.guide ?? ''}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.language, color: Color(0xFF5AD1E5)),
            iconSize: 30,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                        AppLocalizations.of(context)!
                            .audioGuideLanguageSelection,
                        textAlign: TextAlign.center),
                    content: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _currentLanguage,
                          isExpanded: true,
                          icon: Icon(Icons.language, color: Color(0xFF5AD1E5)),
                          items: ['en', 'ru', 'kk']
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
                              Navigator.of(context).pop();
                            }
                          },
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 10),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(_error!, style: TextStyle(color: Color(0xFF5AD1E5))),
          ),
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
              icon: Icon(Icons.replay_10),
              onPressed: () {
                _audioPlayer.seek(
                    Duration(seconds: _audioPlayer.position.inSeconds - 10));
              },
            ),
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
              icon: Icon(Icons.forward_10),
              onPressed: () {
                _audioPlayer.seek(
                    Duration(seconds: _audioPlayer.position.inSeconds + 10));
              },
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
