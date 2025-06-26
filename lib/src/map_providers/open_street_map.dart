class OpenStreetMapProvider implements MapProvider {
  @override
  Widget buildMap({
    required ValueChanged<LatLng> onLocationChanged,
    LatLng? initialLocation,
    Widget? markerIcon,
  }) {
    return FlutterMap(
      options: MapOptions(
        center: initialLocation ?? LatLng(0, 0),
        zoom: 13.0,
        onTap: (_, latLng) => onLocationChanged(latLng),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: initialLocation ?? LatLng(0, 0),
              builder: (ctx) => markerIcon ?? Icon(Icons.location_pin),
            ),
          ],
        ),
      ],
    );
  }
}