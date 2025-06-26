import 'dart:convert';
import 'package:flutter_local_address_picker/src/geocoding/geocoding_service.dart';
import 'package:flutter_local_address_picker/src/models/lat_lng.dart';
import 'package:http/http.dart' as http;

abstract class GeocodingService {
  Future<String> reverseGeocode(LatLng location);
}

class NominatimService implements GeocodingService {
  @override
  Future<String> reverseGeocode(LatLng location) async {
    final response = await http.get(
      Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=${location.latitude}&lon=${location.longitude}'),
      headers: {'User-Agent': 'flutter_local_address_picker'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return _formatAddress(data);
    }
    throw Exception('Failed to fetch address');
  }

  String _formatAddress(Map<String, dynamic> data) {
    final address = data['address'] as Map<String, dynamic>;
    return [
      address['house_number'],
      address['road'],
      address['suburb'],
      address['city'],
      address['state'],
      address['country'],
    ].where((part) => part != null).join(', ');
  }
}