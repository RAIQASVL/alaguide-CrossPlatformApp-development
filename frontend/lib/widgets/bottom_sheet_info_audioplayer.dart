import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/alaguide_object_model.dart';
import 'package:frontend/controllers/audio_player_controller.dart';
import 'package:frontend/widgets/audioplayer_widget.dart';

class BottomSheetInfo extends ConsumerWidget {
  final AlaguideObject object;

  const BottomSheetInfo({Key? key, required this.object}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(object.title ?? '',
              style: Theme.of(context).textTheme.headlineLarge),
          SizedBox(height: 8),
          Text(object.description ?? ''),
          SizedBox(height: 16),
          AudioPlayerWidget(audio_url: object.audio_url ?? ''),
          ElevatedButton(
            onPressed: () {
              if (object.audio_url != null) {
                ref
                    .read(audioPlayerControllerProvider.notifier)
                    .playAudio(object.audio_url!);
              }
            },
            child: Text('Play Audio Guide'),
          ),
        ],
      ),
    );
  }
}
