import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({Key? key, required this.audioUrl}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      print('Loading audio from: ${widget.audioUrl}');
      await _audioPlayer.setUrl(widget.audioUrl);
      _audioPlayer.playerStateStream.listen((state) {
        setState(() {
          _isPlaying = state.playing;
        });
      });
    } catch (e) {
      print('Error loading audio: $e');
      setState(() {
        _error = 'Error loading audio. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Text(_error!,
          style: TextStyle(color: Colors.red, fontSize: 16));
    }

    return Column(
      children: [
        StreamBuilder<Duration?>(
          stream: _audioPlayer.positionStream,
          builder: (context, snapshot) {
            final position = snapshot.data ?? Duration.zero;
            final duration = _audioPlayer.duration ?? Duration.zero;
            return Slider(
              value: position.inSeconds.toDouble(),
              max: duration.inSeconds.toDouble(),
              onChanged: (value) {
                _audioPlayer.seek(Duration(seconds: value.toInt()));
              },
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
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
