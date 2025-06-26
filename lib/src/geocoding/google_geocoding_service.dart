import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'geocoding_service.dart';
import 'dart:convert';


class GoogleGeocodingService implements GeocodingService {
  final String apiKey;
  final String language;

  const GoogleGeocodingService({
    required this.apiKey,
    this.language = 'en',
  });

  @override
  Future<String> reverseGeocode(LatLng location) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?'
      'latlng=${location.latitude},${location.longitude}'
      '&key=$apiKey&language=$language'
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);
    
    if (data['status'] == 'OK' && data['results'].isNotEmpty) {
      return data['results'][0]['formatted_address'];
    }
    throw Exception('Failed to reverse geocode: ${data['status']}');
  }

  @override
  Future<LatLng?> geocode(String address) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?'
      'address=${Uri.encodeComponent(address)}'
      '&key=$apiKey&language=$language'
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);
    
    if (data['status'] == 'OK' && data['results'].isNotEmpty) {
      final location = data['results'][0]['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    }
    return null;
  }
}