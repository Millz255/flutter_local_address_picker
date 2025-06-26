import 'package:flutter_local_address_picker/src/geocoding/nominatim_service.dart';
import 'package:latlong2/latlong.dart';

class MockGeocodingService implements GeocodingService {
  @override
  Future<String> reverseGeocode(LatLng location) async {
    return 'Mock Street, Mock City, Mock Country';
  }
}
