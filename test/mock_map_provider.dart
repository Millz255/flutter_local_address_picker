import 'package:flutter/material.dart';
import 'package:flutter_local_address_picker/src/map_providers/map_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<MapProvider>()])
class MockMapProvider extends Mock implements MapProvider {
  @override
  Widget buildMap({
    required ValueChanged<LatLng> onLocationChanged,
    LatLng? initialLocation,
    Widget? markerIcon,
    double? zoom,
    double? markerSize,
    bool interactive = true,
  }) =>
      super.noSuchMethod(
        Invocation.method(#buildMap, [], {
          #onLocationChanged: onLocationChanged,
          #initialLocation: initialLocation,
          #markerIcon: markerIcon,
          #zoom: zoom,
          #markerSize: markerSize,
          #interactive: interactive,
        }),
        returnValue: Container(),
        returnValueForMissingStub: Container(),
      );

  @override
  String get providerName => super.noSuchMethod(
        Invocation.getter(#providerName),
        returnValue: 'Mock Map Provider',
        returnValueForMissingStub: 'Mock Map Provider',
      );
}