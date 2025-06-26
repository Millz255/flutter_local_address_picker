import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_local_address_picker/src/map_providers/map_provider.dart';

class FakeMapProvider extends MapProvider {
  @override
  Widget buildMap({
    required ValueChanged<LatLng> onLocationChanged,
    LatLng? initialLocation,
    Widget? markerIcon,
    double? zoom,
    double? markerSize,
    bool interactive = true,
  }) {
    return Container();
  }

  @override
  String get providerName => 'FakeMapProvider';
}
