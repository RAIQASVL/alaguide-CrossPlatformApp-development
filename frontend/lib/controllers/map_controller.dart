import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:frontend/providers/map_logic_provider.dart';
import 'package:frontend/providers/content_provider.dart';
import 'package:frontend/models/alaguide_object_model.dart';
import 'package:frontend/constants/google_maps_api_key.dart';

class MapController {
  final WidgetRef ref;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Location _locationController = Location();
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  MapController(this.ref);

  void init() {
    ref.read(contentServiceProvider).fetchAlaguideObjects();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
  }

  Future<LatLng> getInitialPosition() async {
    await getCurrentLocation();
    final currentPosition = ref.read(currentPositionProvider);
    if (currentPosition != null) {
      return currentPosition;
    } else {
      return const LatLng(43.2220, 76.8512); // Almaty coordinates
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final LocationData currentLocation =
        await _locationController.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      ref.read(currentPositionProvider.notifier).state =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
    }
  }

  Future<void> updateCameraPosition(LatLng pos) async {
    final GoogleMapController controller = await mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  void updateMarkers() {
    final alaguideObjects = ref.read(contentProvider).value ?? [];
    ref.read(markersProvider.notifier).state = alaguideObjects
        .map((alaguideObject) => Marker(
              markerId: MarkerId(alaguideObject.ala_object_id.toString()),
              position: LatLng(alaguideObject.coordinates.latitude,
                  alaguideObject.coordinates.longitude),
              infoWindow: InfoWindow(title: alaguideObject.title ?? ''),
              onTap: () => showAlaguideObjectInfo(alaguideObject),
            ))
        .toSet();
  }

  Future<void> showAlaguideObjectInfo(AlaguideObject alaguideObject) async {
    showModalBottomSheet(
      context: scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(alaguideObject.title ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(alaguideObject.description ?? ''),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => playAudio(alaguideObject),
                child: const Text('Play Audio Guide'),
              ),
            ],
          ),
        );
      },
    );
  }

  void playAudio(AlaguideObject alaguideObject) {
    print('Playing audio for ${alaguideObject.landmark ?? ''}');
  }

  Future<void> showAlaguideObjectsList() async {
    final alaguideObjectsAsyncValue = ref.read(contentProvider);
    showDialog(
      context: scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Content'),
          content: SizedBox(
            width: double.maxFinite,
            child: alaguideObjectsAsyncValue.when(
              data: (alaguideObjects) => ListView.builder(
                itemCount: alaguideObjects.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(alaguideObjects[index].landmark ?? ''),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
          ),
        );
      },
    );
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 3,
    );
    ref.read(polylinesProvider.notifier).state = {id: polyline};
  }

  void goToMyLocation() async {
    await getCurrentLocation();
    final currentPosition = ref.read(currentPositionProvider);
    if (currentPosition != null) {
      updateCameraPosition(currentPosition);
    }
  }
}
