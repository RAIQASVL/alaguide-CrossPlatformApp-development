import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:frontend/consts.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


// Providers
final currentPositionProvider = StateProvider<LatLng?>((ref) => null);
final landmarksProvider = StateNotifierProvider<LandmarksNotifier, List<Landmark>>((ref) => LandmarksNotifier());
final polylinesProvider = StateProvider<Map<PolylineId, Polyline>>((ref) => {});
final markersProvider = StateProvider<Set<Marker>>((ref) => {});

class LandmarksNotifier extends StateNotifier<List<Landmark>> {
  LandmarksNotifier() : super([]);

  Future<void> fetchLandmarks() async {
    try {
      final response = await http.get(Uri.parse('YOUR_BACKEND_API_URL/landmarks'));
      if (response.statusCode == 200) {
        List<dynamic> landmarksJson = json.decode(response.body);
        state = landmarksJson.map((json) => Landmark.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load landmarks');
      }
    } catch (e) {
      print('Error fetching landmarks: $e');
      // Show error message to user
    }
  }
}
class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    ref.read(landmarksProvider.notifier).fetchLandmarks();
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = ref.watch(currentPositionProvider);
    final landmarks = ref.watch(landmarksProvider);
    final polylines = ref.watch(polylinesProvider);
    final markers = ref.watch(markersProvider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('ALAGUIDE'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'ALAGUIDE Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Current City'),
              onTap: () {
                // Handle navigation
              },
            ),
            ListTile(
              title: Text('Content'),
              onTap: () {
                _showLandmarksList();
              },
            ),
            ListTile(
              title: Text('Current Language'),
              onTap: () {
                // Handle navigation
              },
            ),
            ListTile(
              title: Text('About Project'),
              onTap: () {
                // Handle navigation
              },
            ),
            ListTile(
              title: Text('Support'),
              onTap: () {
                // Handle navigation
              },
            ),
            ListTile(
              title: Text('Feedback'),
              onTap: () {
                // Handle navigation
              },
            ),
          ],
        ),
      ),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: ((GoogleMapController controller) =>
                      _mapController.complete(controller)),
                  initialCameraPosition: CameraPosition(
                    target: currentPosition ?? LatLng(0, 0),
                    zoom: 13,
                  ),
                  markers: markers,
                  polylines: Set<Polyline>.of(polylines.values),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: _goToMyLocation,
                    child: Icon(Icons.my_location),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        ref.read(currentPositionProvider.notifier).state = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _updateCameraPosition(LatLng(currentLocation.latitude!, currentLocation.longitude!));
      }
    });
  }

  Future<void> _updateCameraPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  void _updateMarkers() {
      final landmarks = ref.read(landmarksProvider);
      ref.read(markersProvider.notifier).state = landmarks.map((landmark) => Marker(
        markerId: MarkerId(landmark.id.toString()),
        position: LatLng(landmark.latitude, landmark.longitude),
        infoWindow: InfoWindow(title: landmark.name),
        onTap: () => _showLandmarkInfo(landmark),
      )).toSet();
  }

  Future<void> _showLandmarkInfo(Landmark landmark) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(landmark.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(landmark.description),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _playAudio(landmark),
                child: Text('Play Audio Guide'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _playAudio(Landmark landmark) {
    // Implement audio playback logic here
    print('Playing audio for ${landmark.name}');
  }

  Future<void> _showLandmarksList() async {
    final landmarks = ref.read(landmarksProvider);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Content'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: landmarks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(landmarks[index].name),
                  onTap: () {
                    Navigator.pop(context);
                    _showRoute(landmarks[index]);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _showRoute(Landmark destination) async {
    final currentPosition = ref.read(currentPositionProvider);
    if (currentPosition == null) return;

    try {
      List<LatLng> polylineCoordinates = await getPolylinePoints(
        currentPosition!,
        LatLng(destination.latitude, destination.longitude),
      );
      _generatePolyLineFromPoints(polylineCoordinates);
      _updateCameraPosition(LatLng(destination.latitude, destination.longitude));
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
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      throw Exception(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void _generatePolyLineFromPoints(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 3,
    );
    ref.read(polylinesProvider.notifier).state = {id: polyline};
  }

  void _goToMyLocation() async {
    final currentPosition = ref.read(currentPositionProvider);
    if (currentPosition != null) {
      _updateCameraPosition(currentPosition!);
    }
  }
}

class Landmark {
  final int id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;

  Landmark({required this.id, required this.name, required this.description, required this.latitude, required this.longitude});

  factory Landmark.fromJson(Map<String, dynamic> json) {
    return Landmark(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
