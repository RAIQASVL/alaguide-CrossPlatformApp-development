import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/alaguide_object_model.dart';
import 'package:frontend/providers/alaguide_object_providers.dart';

class ContentPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alaguideObjectsAsyncValue = ref.watch(alaguideObjectProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Content'),
      ),
      body: alaguideObjectsAsyncValue.when(
        data: (alaguideObjects) {
          if (alaguideObjects.isEmpty) {
            return Center(child: Text('No content available.'));
          }
          return ListView.builder(
            itemCount: alaguideObjects.length,
            itemBuilder: (context, index) {
              final alaguideObject = alaguideObjects[index];
              return ListTile(
                leading: alaguideObject.image_url != null
                    ? Image.network(alaguideObject.image_url!,
                        width: 50, height: 50, fit: BoxFit.cover)
                    : Icon(Icons.image_not_supported),
                title: Text(alaguideObject.title ?? 'Unknown'),
                subtitle: Text(alaguideObject.description ?? ''),
                onTap: () {
                  _showDetailDialog(context, alaguideObject);
                },
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, AlaguideObject object) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(object.title ?? 'Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (object.image_url != null) Image.network(object.image_url!),
                SizedBox(height: 16),
                Text('Description: ${object.description ?? ''}'),
                Text('Author: ${object.author ?? ''}'),
                Text('Guide: ${object.guide ?? ''}'),
                Text('Category: ${object.category ?? ''}'),
                Text(
                    'Location: ${object.landmark}, ${object.city}, ${object.country}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            if (object.audio_url != null)
              TextButton(
                child: Text('Play Audio'),
                onPressed: () {
                  // Implement audio playback logic here
                  print('Playing audio: ${object.audio_url}');
                },
              ),
          ],
        );
      },
    );
  }
}
