import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/widgets/bottom_sheet_info_audioplayer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:frontend/models/alaguide_object_model.dart';
import 'package:frontend/services/content_service.dart';
import 'package:frontend/providers/content_provider.dart';
import 'package:frontend/providers/map_logic_provider.dart';

class MapMarkerController extends StateNotifier<Set<Marker>> {
  final Ref _ref;

  MapMarkerController(this._ref) : super({});

  Future<void> createMarkers() async {
    try {
      // Fetch the Alaguide objects using the service
      final alaguideObjects =
          await _ref.read(contentServiceProvider).fetchAlaguideObjects();
      print('Fetched ${alaguideObjects.length} AlaguideObjects'); // Debug print

      // Convert the fetched objects into a set of markers
      final markers = alaguideObjects
          .map((obj) => Marker(
                markerId: MarkerId(obj.ala_object_id.toString()),
                position: obj.coordinates,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure),
                onTap: () => _showObjectInfo(obj),
              ))
          .toSet();

      print('Created ${markers.length} markers'); // Debug print

      // Update the state with the new markers
      state = markers;
      print('State updated with ${state.length} markers'); // Debug print
    } catch (e) {
      // Handle error (e.g., show a message to the user)
      print('Error creating markers: $e');
    }
  }

  void _showObjectInfo(AlaguideObject obj) {
    final context = _ref.read(scaffoldKeyProvider).currentContext;
    if (context != null) {
      showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheetInfo(object: obj),
      );
    }
  }
}

// Provide the MapMarkerController to the rest of the app
final mapMarkerControllerProvider =
    StateNotifierProvider<MapMarkerController, Set<Marker>>((ref) {
  return MapMarkerController(ref);
});
