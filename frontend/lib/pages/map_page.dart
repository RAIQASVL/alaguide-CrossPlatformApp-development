import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/pages/content_page.dart';
import 'package:frontend/pages/current_city_page.dart';
import 'package:frontend/pages/language_selection_page.dart';
import 'package:frontend/models/city_model.dart';
import 'package:frontend/providers/city_provider.dart';
import 'package:frontend/providers/content_provider.dart';
import 'package:frontend/widgets/bottom_sheet_info_audioplayer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/providers/language_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/controllers/map_controller.dart';
import 'package:frontend/providers/map_logic_provider.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/controllers/animation_controller.dart';
import 'package:frontend/controllers/map_marker_controller.dart';
import 'package:frontend/models/alaguide_object_model.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  late MapController _mapController;
  GoogleMapController? _googleMapController;
  LatLng _initialPosition = LatLng(43.2220, 76.8512);

  @override
  void initState() {
    super.initState();
    // Initialize MapController and load markers
    _mapController = MapController(ref);
    _mapController.init();
    _initializeMap();

    // Load the markers from the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapMarkerControllerProvider.notifier).createMarkers();
    });
  }

  Future<void> _initializeMap() async {
    _initialPosition = await _mapController.getInitialPosition();
    setState(() {});
  }

  Future<void> _initializeMarkers() async {
    try {
      await ref.read(mapMarkerControllerProvider.notifier).createMarkers();
      print('Markers initialized'); // Debug print
    } catch (e) {
      print('Error initializing markers: $e'); // Debug print
    }
  }

  void _moveToCity(City city) {
    if (_googleMapController != null) {
      _googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: city.coordinates,
            zoom: 12.0,
          ),
        ),
      );
    }
  }

  void _goToMyLocation() {
    _mapController.goToMyLocation();
  }

  Widget _buildDrawer() {
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    final theme = Theme.of(context);
    final logoColor = theme.appBarTheme.iconTheme?.color ?? Colors.white;
    final currentLanguage = ref.watch(languageProvider);

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
            leading: const Icon(Icons.home),
            title: Text(AppLocalizations.of(context)!.home),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.pin_drop_sharp),
            title: Text(AppLocalizations.of(context)!.currentCity),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CurrentCityPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.collections_bookmark),
            title: Text(AppLocalizations.of(context)!.content),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContentPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.language),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LanguageSelectionPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(AppLocalizations.of(context)!.aboutProject),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_money_outlined),
            title: Text(AppLocalizations.of(context)!.supportProject),
            onTap: () {
              // Handle navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.markunread_rounded),
            title: Text(AppLocalizations.of(context)!.feedback),
            onTap: () {
              // Handle navigation
            },
          ),
        ],
      ),
    );
  }

  Set<Marker> _createAnimatedMarkers(List<AlaguideObject> objects) {
    return objects.map((obj) {
      return Marker(
        markerId: MarkerId(obj.ala_object_id.toString()),
        position: obj.coordinates,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        onTap: () => _showObjectInfo(obj),
      );
    }).toSet();
  }

  void _showObjectInfo(AlaguideObject obj) {
    showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheetInfo(object: obj),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCity = ref.watch(selectedCityProvider);
    final polylines = ref.watch(polylinesProvider);
    final alaguideObjectsAsync = ref.watch(contentProvider);
    // final markers = ref.watch(mapMarkerControllerProvider);
    final scaffoldKey = _mapController.scaffoldKey;

    ref.listen<City?>(selectedCityProvider, (previous, next) {
      if (next != null) {
        _moveToCity(next);
      }
    });

    return Scaffold(
      key: _mapController.scaffoldKey,
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _googleMapController = controller;
              _mapController.onMapCreated(controller);
            },
            initialCameraPosition: CameraPosition(
              target: selectedCity?.coordinates ?? _initialPosition,
              zoom: 13,
            ),
            markers: alaguideObjectsAsync.when(
              data: (alaguideObjects) =>
                  _createAnimatedMarkers(alaguideObjects),
              loading: () =>
                  {}, // Optionally display a loading marker or empty set
              error: (err, stack) {
                print('Error loading markers: $err');
                return {};
              },
            ),
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
              onPressed: _goToMyLocation,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }
}
