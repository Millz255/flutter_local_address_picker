import 'package:mockito/annotations.dart';
import 'package:flutter_local_address_picker/src/geocoding/nominatim_service.dart';
import 'package:flutter_local_address_picker/src/map_providers/map_provider.dart';
import 'fake_map_provider.dart';

@GenerateMocks([
  GeocodingService,
  FakeMapProvider,
])
void main() {}
