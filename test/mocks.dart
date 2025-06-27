import 'package:mockito/annotations.dart';
import 'package:flutter_local_address_picker/src/geocoding/geocoding_service.dart';
import 'package:flutter_local_address_picker/src/map_providers/map_provider.dart';

@GenerateMocks([], customMocks: [
  MockSpec<GeocodingService>(as: #MockGeocodingService),
  MockSpec<MapProvider>(as: #MockMapProvider),
])
void main() {}