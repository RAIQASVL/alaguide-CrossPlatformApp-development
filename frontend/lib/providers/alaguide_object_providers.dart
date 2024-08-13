import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/alaguide_object_model.dart';
import 'package:frontend/services/alaguide_object_service.dart';

final alaguideObjectServiceProvider = Provider<AlaguideObjectService>((ref) {
  return AlaguideObjectService();
});

final alaguideObjectProvider =
    FutureProvider<List<AlaguideObject>>((ref) async {
  final service = ref.watch(alaguideObjectServiceProvider);
  return service.fetchAlaguideObjects();
});
