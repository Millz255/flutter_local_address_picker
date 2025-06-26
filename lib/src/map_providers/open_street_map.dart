import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong2.dart';

abstract class MapProvider {
  Widget buildMap({
    required ValueChanged<LatLng> onLocationChanged,
    LatLng? initialLocation,
    Widget? markerIcon,
    double? zoom,
  });
}

class OpenStreetMapProvider implements MapProvider {
  @override
  Widget buildMap({
    required ValueChanged<LatLng> onLocationChanged,
    LatLng? initialLocation,
    Widget? markerIcon,
    double? zoom = 15.0,
  }) {
    final marker = Marker(
      width: 40.0,
      height: 40.0,
      point: initialLocation ?? const LatLng(0, 0),
      builder: (ctx) => markerIcon ?? const Icon(Icons.location_pin, size: 40),
    );

    return FlutterMap(
      options: MapOptions(
        center: initialLocation ?? const LatLng(0, 0),
        zoom: zoom!,
        onTap: (_, latLng) => onLocationChanged(latLng),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.flutter_local_address_picker',
        ),
        MarkerLayer(markers: [marker]),
      ],
    );
  }
}