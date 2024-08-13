import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/alaguide_object_model.dart';
import 'package:frontend/services/content_service.dart';

final contentServiceProvider = Provider<ContentService>((ref) {
  return ContentService();
});

final contentProvider = FutureProvider<List<AlaguideObject>>((ref) async {
  final service = ref.watch(contentServiceProvider);
  return service.fetchAlaguideObjects();
});
