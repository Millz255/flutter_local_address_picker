import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong2.dart';

abstract class MapProvider {
  Widget buildMap({
    required ValueChanged<LatLng> onLocationChanged,
    LatLng? initialLocation,
    Widget? markerIcon,
    double? zoom,
    List<Marker> additionalMarkers = const [],
    String tileLayerUrlTemplate = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  });
}

class OpenStreetMapProvider implements MapProvider {
  @override
  Widget buildMap({
    required ValueChanged<LatLng> onLocationChanged,
    LatLng? initialLocation,
    Widget? markerIcon,
    double zoom = 15.0,
    List<Marker> additionalMarkers = const [],
    String tileLayerUrlTemplate = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  }) {
    final defaultLocation = const LatLng(0, 0);
    final centerLocation = initialLocation ?? defaultLocation;

    final marker = Marker(
      width: 40.0,
      height: 40.0,
      point: centerLocation,
      builder: (ctx) => markerIcon ?? const Icon(Icons.location_pin, size: 40),
    );

    final markers = [marker, ...additionalMarkers];

    return FlutterMap(
      options: MapOptions(
        center: centerLocation,
        zoom: zoom,
        onTap: (_, latLng) => onLocationChanged(latLng),
      ),
      children: [
        TileLayer(
          urlTemplate: tileLayerUrlTemplate,
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.flutter_local_address_picker',
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
