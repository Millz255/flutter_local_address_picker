import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_address_picker/flutter_local_address_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:latlong2/latlong.dart';

import 'mocks.mocks.dart';  // Generated mock classes

void main() {
  late MockGeocodingService mockGeocodingService;
  late MockMapProvider mockMapProvider;

  const testLocation = LatLng(40.7128, -74.0060);
  const testAddress = '123 Main St, New York';

  setUp(() {
    mockGeocodingService = MockGeocodingService();
    mockMapProvider = MockMapProvider();
  });

  testWidgets('AddressPicker shows loading when geocoding', (tester) async {
    when(mockGeocodingService.reverseGeocode(testLocation))
        .thenAnswer((_) async => testAddress);
    when(mockMapProvider.buildMap(
      onLocationChanged: anyNamed('onLocationChanged'),
      initialLocation: anyNamed('initialLocation'),
    )).thenReturn(Container());

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: AddressPicker(
          onAddressPicked: (_) {},
          geocodingService: mockGeocodingService,
          mapProvider: mockMapProvider,
        ),
      ),
    ));

    final onLocationChanged = verify(mockMapProvider.buildMap(
      onLocationChanged: captureAnyNamed('onLocationChanged'),
      initialLocation: anyNamed('initialLocation'),
    )).captured.single as ValueChanged<LatLng>;

    onLocationChanged(testLocation);

    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('AddressPicker displays address after geocoding', (tester) async {
    when(mockGeocodingService.reverseGeocode(testLocation))
        .thenAnswer((_) async => testAddress);
    when(mockMapProvider.buildMap(
      onLocationChanged: anyNamed('onLocationChanged'),
      initialLocation: anyNamed('initialLocation'),
    )).thenReturn(Container());

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: AddressPicker(
          onAddressPicked: (_) {},
          geocodingService: mockGeocodingService,
          mapProvider: mockMapProvider,
        ),
      ),
    ));

    final onLocationChanged = verify(mockMapProvider.buildMap(
      onLocationChanged: captureAnyNamed('onLocationChanged'),
      initialLocation: anyNamed('initialLocation'),
    )).captured.single as ValueChanged<LatLng>;

    onLocationChanged(testLocation);

    await tester.pumpAndSettle();
    expect(find.text(testAddress), findsOneWidget);
  });

  testWidgets('AddressPicker calls onAddressPicked with correct data', (tester) async {
    when(mockGeocodingService.reverseGeocode(testLocation))
        .thenAnswer((_) async => testAddress);
    when(mockMapProvider.buildMap(
      onLocationChanged: anyNamed('onLocationChanged'),
      initialLocation: anyNamed('initialLocation'),
    )).thenReturn(Container());

    AddressResult? result;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: AddressPicker(
          onAddressPicked: (r) => result = r,
          geocodingService: mockGeocodingService,
          mapProvider: mockMapProvider,
        ),
      ),
    ));

    final onLocationChanged = verify(mockMapProvider.buildMap(
      onLocationChanged: captureAnyNamed('onLocationChanged'),
      initialLocation: anyNamed('initialLocation'),
    )).captured.single as ValueChanged<LatLng>;

    onLocationChanged(testLocation);

    await tester.pumpAndSettle();
    expect(result?.address, testAddress);
    expect(result?.coordinates, testLocation);
  });
}
