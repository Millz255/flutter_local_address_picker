import 'package:latlong2/latlong.dart';

abstract class GeocodingService {
  const GeocodingService();
  
  Future<String> reverseGeocode(LatLng location);
  Future<LatLng?> geocode(String address);
}