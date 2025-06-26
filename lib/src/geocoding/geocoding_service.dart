import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


abstract class GeocodingService {
  const GeocodingService();
  
  Future<String> reverseGeocode(LatLng location);
  Future<LatLng?> geocode(String address);
}