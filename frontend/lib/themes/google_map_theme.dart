import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/theme_provider.dart';

class GoogleMapTheme extends ConsumerStatefulWidget {
  final Widget Function(BuildContext, String?) builder;

  const GoogleMapTheme({Key? key, required this.builder}) : super(key: key);

  @override
  ConsumerState<GoogleMapTheme> createState() => _GoogleMapThemeState();
}

class _GoogleMapThemeState extends ConsumerState<GoogleMapTheme> {
  String? _mapStyle;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
    final themeMode = ref.read(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    final stylePath = isDarkMode
        ? 'assets/map_styles/night_theme.json'
        : 'assets/map_styles/retro_theme.json';

    _mapStyle = await rootBundle.loadString(stylePath);
    if (_mapController != null) {
      await _mapController!.setMapStyle(_mapStyle);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadMapStyle();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(themeProvider, (_, __) => _loadMapStyle());
    return widget.builder(
      context,
      _mapStyle,
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_mapStyle != null) {
      _mapController!.setMapStyle(_mapStyle);
    }
  }
}
