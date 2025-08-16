import 'dart:ui';

import 'package:maplibre_gl/maplibre_gl.dart';

import '../../core/models/poi.dart';

Future<void> renderPoiMarkers(
  MaplibreMapController controller,
  List<Poi> pois,
) async {
  await controller.clearSymbols();
  for (final poi in pois) {
    await controller.addSymbol(
      SymbolOptions(
        geometry: LatLng(poi.lat, poi.lon),
        iconImage: 'marker-15',
        textField: poi.name,
        textOffset: const Offset(0, 1.2),
      ),
    );
  }
}
