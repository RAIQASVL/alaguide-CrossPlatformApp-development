import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/pages/content_page.dart';
import 'package:frontend/pages/current_city_page.dart';
import 'package:frontend/pages/language_selection_page.dart';
import 'package:frontend/models/city_model.dart';
import 'package:frontend/providers/city_provider.dart';
import 'package:frontend/services/city_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/providers/language_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/controllers/map_controller.dart';
import 'package:frontend/providers/logic_providers.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/controllers/animation_controller.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  late MapController _mapController;
  GoogleMapController? _googleMapController;
  LatLng _initialPosition = LatLng(43.2220, 76.8512); // Default to Almaty

  @override
  void initState() {
    super.initState();
    _mapController = MapController(ref);
    _mapController.init();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    _initialPosition = await _mapController.getInitialPosition();
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    final polylines = ref.watch(polylinesProvider);
    final markers = ref.watch(markersProvider);
    final selectedCity = ref.watch(selectedCityProvider);

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
