import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import 'map_provider.dart';

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
    final markerPoint = initialLocation ?? const LatLng(0, 0);
    final size = markerSize ?? 40.0;

    return FlutterMap(
      options: MapOptions(
        initialCenter: markerPoint,
        initialZoom: zoom,
        interactionOptions: InteractionOptions(
          flags: interactive
              ? InteractiveFlag.all
              : InteractiveFlag.none,
        ),
        onTap: interactive
            ? (tapPosition, latLng) => onLocationChanged(latLng)
            : null,
      ),
      children: [
        TileLayer(
          urlTemplate: tileUrlTemplate,
          subdomains: tileSubdomains,
          userAgentPackageName: userAgent,
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: markerPoint,
              width: size,
              height: size,
              child: markerIcon ??
                  const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
            ),
          ],
        ),
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
        ),
      ],
    );
  }
}
