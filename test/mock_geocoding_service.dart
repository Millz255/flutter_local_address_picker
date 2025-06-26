import 'package:flutter_local_address_picker/src/geocoding/geocoding_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<GeocodingService>()])
class MockGeocodingService extends Mock implements GeocodingService {
  @override
  Future<String> reverseGeocode(LatLng location) => super.noSuchMethod(
        Invocation.method(#reverseGeocode, [location]),
        returnValue: Future.value('Mock Address'),
        returnValueForMissingStub: Future.value('Mock Address'),
      );

  @override
  Future<LatLng?> geocode(String address) => super.noSuchMethod(
        Invocation.method(#geocode, [address]),
        returnValue: Future.value(const LatLng(0, 0)),
        returnValueForMissingStub: Future.value(const LatLng(0, 0)),
      );
}