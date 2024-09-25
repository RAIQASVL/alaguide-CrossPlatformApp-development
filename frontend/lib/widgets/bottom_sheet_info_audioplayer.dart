import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:frontend/models/alaguide_object_model.dart';
import 'package:frontend/widgets/audioplayer_widget.dart';
import 'package:frontend/widgets/processed_image.dart';
import 'package:frontend/widgets/full_screen_audioplayer_widget.dart'; // Импортируем новый виджет

class BottomSheetInfo extends ConsumerWidget {
  final AlaguideObject object;
  final ScrollController scrollController;

  const BottomSheetInfo({
    Key? key,
    required this.object,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Stack(
              children: [
                AudioPlayerWidget(object: object),
              ],
            ),
            SizedBox(height: 16),
            Positioned(
              right: 10,
              top: 20,
              child: IconButton(
                icon: Icon(Icons.fullscreen_rounded, color: Color(0xFF5AD1E5)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          FullScreenAudioPlayer(object: object),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
