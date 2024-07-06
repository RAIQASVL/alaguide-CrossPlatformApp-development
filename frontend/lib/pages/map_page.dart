import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/themes/app_theme.dart';
import 'package:frontend/controllers/map_controller.dart';
import 'package:frontend/providers/logic_providers.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/models/landmark.dart';
import 'package:frontend/controllers/animation_controller.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
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
                ),
              ],
            ),
    );
  }

  Widget _buildDrawer() {
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    final theme = Theme.of(context);
    final logoColor = theme.appBarTheme.iconTheme?.color ?? Colors.white;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.appBarTheme.backgroundColor,
            ),
            child: SizedBox.expand(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/alaguide_icon_graphic.svg',
                          color: logoColor,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        Expanded(
                          flex: 1,
                          child: FractionallySizedBox(
                            widthFactor: 0.5,
                            heightFactor: 0.2,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SvgPicture.asset(
                                'assets/images/alaguide_snake_graphic.svg',
                                color: logoColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.pin_drop_sharp),
            title: Text('Current City'),
            onTap: () {
              // Handle navigation
            },
          ),
          ListTile(
            leading: Icon(Icons.collections_bookmark),
            title: Text('Content'),
            onTap: () {
              _mapController.showLandmarksList();
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Current Language'),
            onTap: () {
              // Handle navigation
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About Project'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money_outlined),
            title: Text('Support Project'),
            onTap: () {
              // Handle navigation
            },
          ),
          ListTile(
            leading: Icon(Icons.markunread_rounded),
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
