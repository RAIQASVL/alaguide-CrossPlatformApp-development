import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final currentPositionProvider = StateProvider<LatLng?>((ref) => null);
final polylinesProvider = StateProvider<Map<PolylineId, Polyline>>((ref) => {});
final markersProvider = StateProvider<Set<Marker>>((ref) => {});
final scaffoldKeyProvider = Provider<GlobalKey<ScaffoldState>>((ref) {
  return GlobalKey<ScaffoldState>();
});
