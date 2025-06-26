import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_address_picker/flutter_local_address_picker.dart';
import 'mock_geocoding_service.dart';
import 'mock_map_provider.dart';
import 'package:latlong2/latlong.dart';

void main() {
  testWidgets('AddressPicker returns correct address and coordinates',
      (WidgetTester tester) async {
    AddressResult? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddressPicker(
            onAddressPicked: (picked) {
              result = picked;
            },
            mapProvider: MockMapProvider(),
            geocodingService: MockGeocodingService(),
          ),
        ),
      ),
    );

    
    final mockTapLocation = LatLng(12.34, 56.78);
    final state =
        tester.state(find.byType(AddressPicker)) as dynamic;

    await tester.runAsync(() async {
      await state._updateAddress(mockTapLocation);
    });

    expect(result, isNotNull);
    expect(result!.address, 'Mock Street, Mock City, Mock Country');
    expect(result!.coordinates.latitude, 12.34);
    expect(result!.coordinates.longitude, 56.78);
  });
}
