import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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

class OpenStreetMapProvider implements MapProvider {
  final List<String> tileSubdomains;
  final String tileUrlTemplate;
  final String userAgent;

  const OpenStreetMapProvider({
    this.tileSubdomains = const ['a', 'b', 'c'],
    this.tileUrlTemplate = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    this.userAgent = 'flutter_local_address_picker',
  });

  @override
  String get providerName => 'OpenStreetMap';

  @override
  Widget buildMap({
    required ValueChanged<LatLng> onLocationChanged,
    LatLng? initialLocation,
    Widget? markerIcon,
    double zoom = 15.0,
    double? markerSize,
    bool interactive = true,
  }) {
    final size = markerSize ?? 40.0;
    final marker = Marker(
      width: size,
      height: size,
      point: initialLocation ?? const LatLng(0, 0),
      builder: (ctx) => markerIcon ?? Icon(Icons.location_pin, size: size),
    );

    return FlutterMap(
      options: MapOptions(
        center: initialLocation ?? const LatLng(0, 0),
        zoom: zoom,
        interactive: interactive,
        onTap: interactive ? (_, latLng) => onLocationChanged(latLng) : null,
      ),
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: tileUrlTemplate,
          subdomains: tileSubdomains,
          userAgentPackageName: userAgent,
        ),
        MarkerLayer(markers: [marker]),
      ],
    );
  }
}

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
    double zoom = 15.0,
    double? markerSize,
    bool interactive = true,
  }) {
    final size = markerSize ?? 40.0;
    final marker = Marker(
      width: size,
      height: size,
      point: initialLocation ?? const LatLng(0, 0),
      builder: (ctx) => markerIcon ?? Icon(Icons.location_pin, size: size),
    );

    return FlutterMap(
      options: MapOptions(
        center: initialLocation ?? const LatLng(0, 0),
        zoom: zoom,
        interactive: interactive,
        onTap: interactive ? (_, latLng) => onLocationChanged(latLng) : null,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://mt.google.com/vt?x={x}&y={y}&z={z}',
          additionalOptions: {
            'apikey': apiKey,
          },
        ),
        MarkerLayer(markers: [marker]),
      ],
    );
  }
}
