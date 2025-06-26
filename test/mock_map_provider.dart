import 'package:flutter/material.dart';
import 'package:flutter_local_address_picker/src/map_providers/open_street_map.dart';
import 'package:latlong2/latlong.dart';

class MockMapProvider implements MapProvider {
  @override
  Widget buildMap({
    required ValueChanged<LatLng> onLocationChanged,
    LatLng? initialLocation,
    Widget? markerIcon,
  }) {

    return GestureDetector(
      onTap: () => onLocationChanged(LatLng(12.34, 56.78)),
      child: Container(
        color: Colors.grey,
        height: 200,
        child: Center(child: Text('Mock Map')),
      ),
    );
  }
}
