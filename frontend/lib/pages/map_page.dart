import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:frontend/controllers/map_controller.dart';
import 'package:frontend/providers/logic_providers.dart';
import 'package:frontend/models/landmark.dart';
import 'package:frontend/controllers/animation_controller.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController(ref);
    _mapController.init();
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = ref.watch(currentPositionProvider);
    final polylines = ref.watch(polylinesProvider);
    final markers = ref.watch(markersProvider);

    return Scaffold(
      key: _mapController.scaffoldKey,
      drawer: _buildDrawer(),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _mapController.onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: currentPosition,
                    zoom: 13,
                  ),
                  markers: markers,
                  polylines: Set<Polyline>.of(polylines.values),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: AnimatedMenuButton(
                    onPressed: () {
                      _mapController.scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: AnimatedLocationButton(
                    onPressed: () {
                      _mapController.goToMyLocation();
                    },
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
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
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
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
              _mapController.showLandmarksList();
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
            Navigator.pushNamed(context, '/');
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
    );
  }
}