import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:frontend/services/alaguide_object_service.dart';
import 'package:frontend/models/alaguide_object_model.dart';

final currentPositionProvider = StateProvider<LatLng?>((ref) => null);
final polylinesProvider = StateProvider<Map<PolylineId, Polyline>>((ref) => {});
final markersProvider = StateProvider<Set<Marker>>((ref) => {});
