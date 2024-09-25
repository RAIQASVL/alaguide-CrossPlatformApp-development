import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/l10n/l10n.dart';
import 'package:frontend/pages/map_page.dart';
import 'package:just_audio/just_audio.dart';
import 'package:frontend/models/alaguide_object_model.dart';
import 'package:frontend/providers/audio_url_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/widgets/processed_image.dart';

class FullScreenAudioPlayer extends ConsumerStatefulWidget {
  final AlaguideObject object;

  const FullScreenAudioPlayer({Key? key, required this.object})
      : super(key: key);

  @override
  _FullScreenAudioPlayerState createState() => _FullScreenAudioPlayerState();
}

class _FullScreenAudioPlayerState extends ConsumerState<FullScreenAudioPlayer> {
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
      _currentLanguage = _availableLanguages.first;
      await _loadAudio(_currentLanguage!);
    } else {
      setState(() {
        _error =
            AppLocalizations.of(context)!.audioNotAvailableInCurrentLanguage;
        style:
        TextStyle(color: Color(0xFF5AD1E5));
      });
    }
  }

  Future<void> _loadAudio(String language) async {
    try {
      final audioInfo = ref.read(audioInfoProvider(widget.object));
      final audioUrl = audioInfo.audioUrls[language];
      if (audioUrl != null) {
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
          _error =
              AppLocalizations.of(context)!.audioNotAvailableInCurrentLanguage;
          style:
          TextStyle(color: Color(0xFF5AD1E5));
        });
      }
    } catch (e) {
      setState(() {
        _error = AppLocalizations.of(context)!.errorLoadingAudio;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.object.title ?? ''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.object.image_url != null)
                ProcessedImage(
                  imageUrl: widget.object.image_url!,
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.6,
                  isCircular: true,
                  fit: BoxFit.cover,
                  isNetwork: true,
                ),
              SizedBox(height: 16),
              Text(
                widget.object
                        .getLocalizedAuthor(AppLocalizations.of(context)!) ??
                    '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 6),
              Text(
                widget.object
                        .getLocalizedTitle(AppLocalizations.of(context)!) ??
                    '',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Color(0xFF5AD1E5),
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6),
              Text(
                '${AppLocalizations.of(context)!.readingGuide} ${widget.object.getLocalizedGuide(AppLocalizations.of(context)!) ?? ''}',
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
                                icon: Icon(Icons.language,
                                    color: Color(0xFF5AD1E5)),
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
              SizedBox(height: 16),
              if (_error != null)
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(_error!,
                        style: TextStyle(color: Color(0xFF5AD1E5)))),
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
                      _audioPlayer.seek(Duration(
                          seconds: _audioPlayer.position.inSeconds - 10));
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
                      _audioPlayer.seek(Duration(
                          seconds: _audioPlayer.position.inSeconds + 10));
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (widget.object.getLocalizedDescription(
                          AppLocalizations.of(context)!) !=
                      null &&
                  widget.object
                      .getLocalizedDescription(AppLocalizations.of(context)!)!
                      .trim()
                      .isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Html(
                      data: widget.object.getLocalizedDescription(
                              AppLocalizations.of(context)!) ??
                          '',
                      style: {
                        "p": Style(
                          textAlign: TextAlign.center,
                          fontSize: FontSize(15),
                          margin: Margins.all(3),
                        ),
                      },
                    ),
                  ],
                ),
              SizedBox(height: 16),
              Positioned(
                right: 10,
                top: 20,
                child: IconButton(
                  icon: Icon(Icons.close_fullscreen_rounded,
                      color: Color(0xFF5AD1E5)),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MapPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
