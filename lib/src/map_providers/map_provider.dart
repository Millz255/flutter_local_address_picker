import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

abstract class MapProvider {
  const MapProvider();
  
  Widget buildMap({
    required ValueChanged<LatLng> onLocationChanged,
    LatLng? initialLocation,
    Widget? markerIcon,
    double? zoom,
    double? markerSize,
    bool interactive = true,
  });

  String get providerName;
}