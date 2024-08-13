import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/alaguide_object_service.dart';

final alaguideObjectControllerProvider = Provider<AlaguideObjectService>((ref) {
  return AlaguideObjectService();
});
