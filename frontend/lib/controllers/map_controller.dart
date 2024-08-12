import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:frontend/providers/logic_providers.dart';
import 'package:frontend/models/landmark.dart';
import 'package:frontend/constants/google_maps_api_key.dart';

class MapController {
  final WidgetRef ref;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Location _locationController = Location();
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  MapController(this.ref);

  void init() {
    ref.read(landmarksProvider.notifier).fetchLandmarks();
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
      // Default to Almaty City coordinates if current location is not available
      return LatLng(43.2220, 76.8512); // Almaty coordinates
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
    final landmarks = ref.read(landmarksProvider);
    ref.read(markersProvider.notifier).state = landmarks
        .map((landmark) => Marker(
              markerId: MarkerId(landmark.id.toString()),
              position: LatLng(landmark.latitude, landmark.longitude),
              infoWindow: InfoWindow(title: landmark.name),
              onTap: () => showLandmarkInfo(landmark),
            ))
        .toSet();
  }

  Future<void> showLandmarkInfo(Landmark landmark) async {
    showModalBottomSheet(
      context: scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(landmark.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(landmark.description),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => playAudio(landmark),
                child: const Text('Play Audio Guide'),
              ),
            ],
          ),
        );
      },
    );
  }

  void playAudio(Landmark landmark) {
    // Implement audio playback logic here
    print('Playing audio for ${landmark.name}');
  }

  Future<void> showLandmarksList() async {
    final landmarks = ref.read(landmarksProvider);
    showDialog(
      context: scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Content'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: landmarks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(landmarks[index].name),
                  onTap: () {
                    Navigator.pop(context);
                    showRoute(landmarks[index]);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> showRoute(Landmark destination) async {
    final currentPosition = ref.read(currentPositionProvider);
    if (currentPosition == null) {
      // If current position is not available, get it first
      await getCurrentLocation();
    }

    final updatedCurrentPosition = ref.read(currentPositionProvider);
    if (updatedCurrentPosition == null) return;

    try {
      List<LatLng> polylineCoordinates = await getPolylinePoints(
        updatedCurrentPosition,
        LatLng(destination.latitude, destination.longitude),
      );
      generatePolyLineFromPoints(polylineCoordinates);
      updateCameraPosition(LatLng(destination.latitude, destination.longitude));
    } catch (e) {
      print('Error getting route: $e');
      // Show error message to user
    }
  }

  Future<List<LatLng>> getPolylinePoints(LatLng start, LatLng end) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineRequest request = PolylineRequest(
      origin: PointLatLng(start.latitude, start.longitude),
      destination: PointLatLng(end.latitude, end.longitude),
      mode: TravelMode.walking,
    );
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: request,
      googleApiKey: GOOGLE_MAPS_API_KEY,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      throw Exception(result.errorMessage);
    }
    return polylineCoordinates;
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
