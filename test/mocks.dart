import 'package:mockito/annotations.dart';
import 'package:flutter_local_address_picker/src/geocoding/nominatim_service.dart';
import 'package:flutter_local_address_picker/src/map_providers/open_street_map.dart';

@GenerateMocks(
  [GeocodingService, MapProvider],
  customMocks: [
    MockSpec<GeocodingService>(as: #MyMockGeocodingService),
    MockSpec<MapProvider>(as: #MyMockMapProvider),
  ],
)
void main() {}
