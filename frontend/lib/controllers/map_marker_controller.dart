import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/content_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:frontend/models/alaguide_object_model.dart';
import 'package:frontend/services/content_service.dart';
import 'package:frontend/widgets/custom_marker.dart';
import 'package:frontend/widgets/bottom_sheet_info_audioplayer.dart';
import 'package:frontend/providers/map_logic_provider.dart';

class MapMarkerController extends StateNotifier<Set<Marker>> {
  final Ref _ref;
  BitmapDescriptor? _cachedCustomMarkerIcon;

  MapMarkerController(this._ref) : super({});

  Future<BitmapDescriptor> _getCustomMarkerIcon() async {
    if (_cachedCustomMarkerIcon != null) {
      return _cachedCustomMarkerIcon!;
    }

    final customMarker = CustomMarker(
      svgAsset: 'assets/images/custom_marker.svg',
      onTap: () {}, // This will be overridden for each marker
    );

    final bytes = await _widgetToImageBytes(customMarker);
    _cachedCustomMarkerIcon = BitmapDescriptor.fromBytes(bytes);
    return _cachedCustomMarkerIcon!;
  }

  Future<Uint8List> _widgetToImageBytes(Widget widget) async {
    final size = const Size(70, 100); // Desired size of the marker

    final repaintBoundary = RenderRepaintBoundary();
    final renderView = RenderView(
      view: WidgetsBinding.instance.platformDispatcher.views.first,
      child: RenderPositionedBox(child: repaintBoundary),
      configuration: ViewConfiguration(
        physicalConstraints: BoxConstraints.tight(size),
        logicalConstraints: BoxConstraints.tight(size),
        devicePixelRatio: 3.0,
      ),
    );

    final pipelineOwner = PipelineOwner();
    final buildOwner = BuildOwner(focusManager: FocusManager());

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: widget,
      ),
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final image = await repaintBoundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final uint8List = byteData!.buffer.asUint8List();

    print(
        'Generated image bytes of length: ${uint8List.length}'); // Debug print

    return uint8List;
  }

  Future<Set<Marker>> createCustomMarkers() async {
    try {
      final alaguideObjects =
          await _ref.read(contentServiceProvider).fetchAlaguideObjects();
      print('Fetched ${alaguideObjects.length} AlaguideObjects');

      final customMarkerIcon = await _getCustomMarkerIcon();

      final markers = alaguideObjects
          .map((obj) => Marker(
                markerId: MarkerId(obj.ala_object_id.toString()),
                position: obj.coordinates,
                icon: customMarkerIcon,
                onTap: () => _showObjectInfo(obj),
              ))
          .toSet();

      print('Created ${markers.length} markers');
      state = markers;
      return markers;
    } catch (e) {
      print('Error creating markers: $e');
      return {};
    }
  }

  void _showObjectInfo(AlaguideObject obj) {
    final context = _ref.read(scaffoldKeyProvider).currentContext;
    if (context != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.2,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return BottomSheetInfo(
              object: obj,
              scrollController: scrollController,
            );
          },
        ),
      );
    }
  }
}

final mapMarkerControllerProvider =
    StateNotifierProvider<MapMarkerController, Set<Marker>>((ref) {
  return MapMarkerController(ref);
});
