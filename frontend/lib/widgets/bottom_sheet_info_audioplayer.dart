import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:frontend/models/alaguide_object_model.dart';
import 'package:frontend/widgets/audioplayer_widget.dart';
import 'package:frontend/widgets/processed_image.dart';

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
            if (object.image_url != null)
              ProcessedImage(
                imageUrl: object.image_url!,
                width: 120,
                height: 120,
                opacity: 0.9,
                isCircular: true,
                fit: BoxFit.cover,
                isNetwork: true,
              ),
            SizedBox(height: 16),
            AudioPlayerWidget(object: object),
            SizedBox(height: 16),
            Html(
              data: object.description ?? '',
              style: {
                "p": Style(
                  textAlign: TextAlign.center, // Центрирование текста
                  fontSize: FontSize(15), // Пример изменения размера шрифта
                  margin: Margins.all(3),
                ),
              },
            ), // Отступы
          ],
        ),
      ),
    );
  }

  Widget _buildProcessedImage(String imageUrl) {
    return Opacity(
      opacity: 0.9,
      child: ClipOval(
        child: Image.network(
          imageUrl,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
