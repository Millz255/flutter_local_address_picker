import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_address_picker/flutter_local_address_picker.dart';

void main() {
  group('AddressPicker Tests', () {
    test('AddressResult equality', () {
      final result1 = AddressResult(
        address: '123 Main St',
        coordinates: const LatLng(40.7128, -74.0060),
      );
      final result2 = AddressResult(
        address: '123 Main St',
        coordinates: const LatLng(40.7128, -74.0060),
      );
      expect(result1, equals(result2));
    });
  });
}