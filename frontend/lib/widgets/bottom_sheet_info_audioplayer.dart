import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/alaguide_object_model.dart';
import 'package:frontend/widgets/audioplayer_widget.dart';

class BottomSheetInfo extends ConsumerWidget {
  final AlaguideObject object;

  const BottomSheetInfo(
      {Key? key,
      required this.object,
      required ScrollController scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (object.image_url != null) Image.network(object.image_url!),
            SizedBox(height: 8),
            Text(object.title ?? '',
                style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 8),
            Text(object.description ?? ''),
            SizedBox(height: 16),
            AudioPlayerWidget(audioUrl: object.audio_url ?? ''),
          ],
        ),
      ),
    );
  }
}
