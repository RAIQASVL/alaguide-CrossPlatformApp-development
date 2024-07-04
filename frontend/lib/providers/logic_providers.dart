import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:frontend/services/landmark_service.dart';
import 'package:frontend/models/landmark.dart';

final currentPositionProvider = StateProvider<LatLng?>((ref) => null);
final landmarksProvider = StateNotifierProvider<LandmarkService, List<Landmark>>((ref) => LandmarkService());
final polylinesProvider = StateProvider<Map<PolylineId, Polyline>>((ref) => {});
final markersProvider = StateProvider<Set<Marker>>((ref) => {});