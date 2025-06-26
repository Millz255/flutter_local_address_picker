import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'map_provider.dart';

class GoogleMapProvider implements MapProvider {
  final String apiKey;
  final String mapType;
  final String language;

  const GoogleMapProvider({
    required this.apiKey,
    this.mapType = 'roadmap',
    this.language = 'en',
  });

  @override
  String get providerName => 'Google Maps';

  @override
  Widget buildMap({
    required ValueChanged<LatLng> onLocationChanged,
    LatLng? initialLocation,
    Widget? markerIcon,
    double? zoom = 15.0,
    double? markerSize,
    bool interactive = true,
  }) {
    return FlutterMap(
      options: MapOptions(
        center: initialLocation ?? const LatLng(0, 0),
        zoom: zoom!,
        interactive: interactive,
        onTap: interactive ? (_, latLng) => onLocationChanged(latLng) : null,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://maps.googleapis.com/maps/api/staticmap?'
              'center={lat},{lng}&zoom={z}&size={width}x{height}&maptype=$mapType'
              '&markers=color:red%7C{lat},{lng}&language=$language&key=$apiKey',
          additionalOptions: {'apiKey': apiKey},
        ),
        if (markerIcon != null)
          MarkerLayer(
            markers: [
              Marker(
                width: markerSize ?? 40.0,
                height: markerSize ?? 40.0,
                point: initialLocation ?? const LatLng(0, 0),
                builder: (ctx) => markerIcon,
              ),
            ],
          ),
      ],
    );
  }
}