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
import 'package:frontend/models/alaguide_object_model.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  late MapController _mapController;
  GoogleMapController? _googleMapController;
  LatLng _initialPosition = LatLng(43.2220, 76.8512);
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _mapController = MapController(ref);
    _mapController.init();
    _initializeMap();
    _loadMarkers();
  }

  Future<void> _initializeMap() async {
    _initialPosition = await _mapController.getInitialPosition();
    setState(() {});
  }

  Future<void> _loadMarkers() async {
    try {
      final alaguideObjects = await ref.read(contentProvider.future);
      final customMarkerIcon = await _createCustomMarkerIcon();

      setState(() {
        _markers = alaguideObjects
            .map((obj) => Marker(
                  markerId: MarkerId(obj.ala_object_id.toString()),
                  position: obj.coordinates,
                  icon: customMarkerIcon,
                  onTap: () => _showObjectInfo(obj),
                ))
            .toSet();
      });

      print('Markers loaded: ${_markers.length}');
    } catch (e) {
      print('Error loading markers: $e');
    }
  }

  Future<BitmapDescriptor> _createCustomMarkerIcon() async {
    final svgString =
        await rootBundle.loadString('assets/images/custom_marker.svg');
    final pictureInfo = await vg.loadPicture(SvgStringLoader(svgString), null);
    final image =
        await pictureInfo.picture.toImage(70, 100); // Adjust size here
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
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
          _buildDrawerItem(Icons.home, AppLocalizations.of(context)!.home, () {
            Navigator.pushNamed(context, '/home');
          }),
          _buildDrawerItem(
              Icons.pin_drop_sharp, AppLocalizations.of(context)!.currentCity,
              () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CurrentCityPage()));
          }),
          _buildDrawerItem(
              Icons.collections_bookmark, AppLocalizations.of(context)!.content,
              () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ContentPage()));
          }),
          _buildDrawerItem(
              Icons.language, AppLocalizations.of(context)!.language, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LanguageSelectionPage()));
          }),
          _buildDrawerItem(
              Icons.info_outline, AppLocalizations.of(context)!.aboutProject,
              () {
            Navigator.pushNamed(context, '/');
          }),
          _buildDrawerItem(Icons.attach_money_outlined,
              AppLocalizations.of(context)!.supportProject, () {
            // Handle navigation
          }),
          _buildDrawerItem(
              Icons.markunread_rounded, AppLocalizations.of(context)!.feedback,
              () {
            // Handle navigation
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _showObjectInfo(AlaguideObject obj) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.2,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) {
          return BottomSheetInfo(
            object: obj,
            scrollController: controller,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCity = ref.watch(selectedCityProvider);
    final polylines = ref.watch(polylinesProvider);

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
            markers: _markers,
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
