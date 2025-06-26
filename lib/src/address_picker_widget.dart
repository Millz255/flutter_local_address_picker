import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';


class AddressResult {
  final String address;
  final LatLng coordinates;
  final Map<String, dynamic>? addressComponents;

  const AddressResult({
    required this.address,
    required this.coordinates,
    this.addressComponents,
  });

  @override
  String toString() {
    return 'AddressResult(address: $address, coordinates: $coordinates)';
  }
}

class AddressPickerTheme {
  final Color primaryColor;
  final Widget? markerIcon;
  final double mapZoom;
  final bool showCurrentLocationButton;
  final EdgeInsetsGeometry? padding;
  final TextStyle? addressTextStyle;

  const AddressPickerTheme({
    this.primaryColor = Colors.blue,
    this.markerIcon,
    this.mapZoom = 15.0,
    this.showCurrentLocationButton = true,
    this.padding,
    this.addressTextStyle,
  });
}


class AddressPickerException implements Exception {
  final String message;
  final dynamic cause;

  const AddressPickerException(this.message, [this.cause]);

  @override
  String toString() => 'AddressPickerException: $message';
}

class NetworkException extends AddressPickerException {
  const NetworkException([dynamic cause])
      : super('Network connectivity issue', cause);
}

class GeocodingException extends AddressPickerException {
  const GeocodingException([dynamic cause])
      : super('Failed to retrieve address', cause);
}

class InvalidLocationException extends AddressPickerException {
  const InvalidLocationException()
      : super('The selected location is invalid');
}

class PermissionDeniedException extends AddressPickerException {
  const PermissionDeniedException()
      : super('Location permission denied');
}


abstract class GeocodingService {
  Future<String> reverseGeocode(LatLng location);
}

class NominatimService implements GeocodingService {
  final String userAgent;

  const NominatimService({this.userAgent = 'flutter_local_address_picker'});

  @override
  Future<String> reverseGeocode(LatLng location) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${location.latitude}&lon=${location.longitude}',
      );

      final response = await http.get(url, headers: {
        'User-Agent': userAgent,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _formatAddress(data);
      } else {
        throw GeocodingException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } on http.ClientException catch (e) {
      throw NetworkException(e);
    } catch (e) {
      throw GeocodingException(e);
    }
  }

  String _formatAddress(Map<String, dynamic> data) {
    final address = data['address'] as Map<String, dynamic>? ?? {};
    final components = [
      address['house_number'],
      address['road'],
      address['village'] ?? address['suburb'],
      address['city'] ?? address['town'],
      address['state'],
      address['postcode'],
      address['country'],
    ].where((part) => part != null).join(', ');

    return components.isNotEmpty ? components : 'Unnamed location';
  }
}


abstract class MapProvider {
  Widget buildMap({
    required ValueChanged<LatLng> onLocationChanged,
    LatLng? initialLocation,
    Widget? markerIcon,
    double? zoom,
  });
}

class OpenStreetMapProvider implements MapProvider {
  @override
  Widget buildMap({
    required ValueChanged<LatLng> onLocationChanged,
    LatLng? initialLocation,
    Widget? markerIcon,
    double? zoom = 15.0,
  }) {
    final marker = Marker(
      width: 40.0,
      height: 40.0,
      point: initialLocation ?? const LatLng(0, 0),
      builder: (ctx) => markerIcon ?? const Icon(Icons.location_pin, size: 40),
    );

    return FlutterMap(
      options: MapOptions(
        center: initialLocation ?? const LatLng(0, 0),
        zoom: zoom!,
        onTap: (_, latLng) => onLocationChanged(latLng),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.flutter_local_address_picker',
        ),
        MarkerLayer(markers: [marker]),
      ],
    );
  }
}


class AddressPicker extends StatefulWidget {
  final ValueChanged<AddressResult> onAddressPicked;
  final ValueChanged<AddressPickerException>? onError;
  final MapProvider mapProvider;
  final GeocodingService geocodingService;
  final AddressPickerTheme? theme;
  final Future<LatLng?>? initialLocation;

  const AddressPicker({
    Key? key,
    required this.onAddressPicked,
    this.onError,
    this.mapProvider = const OpenStreetMapProvider(),
    this.geocodingService = const NominatimService(),
    this.theme,
    this.initialLocation,
  }) : super(key: key);

  @override
  State<AddressPicker> createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
  LatLng? _selectedLocation;
  String? _currentAddress;
  bool _isLoading = false;
  final _debounceTimer = Duration(milliseconds: 500);
  Timer? _debouncer;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    if (widget.initialLocation != null) {
      try {
        final location = await widget.initialLocation;
        if (location != null && mounted) {
          setState(() => _selectedLocation = location);
          _updateAddress(location);
        }
      } catch (e) {
        widget.onError?.call(AddressPickerException('Failed to get initial location', e));
      }
    }
  }

  bool _isValidLocation(LatLng location) {
    return location.latitude.abs() <= 90 && location.longitude.abs() <= 180;
  }

  Future<void> _updateAddress(LatLng location) async {
    if (!_isValidLocation(location)) {
      widget.onError?.call(const InvalidLocationException());
      return;
    }

    _debouncer?.cancel();
    _debouncer = Timer(_debounceTimer, () async {
      if (!mounted) return;

      setState(() => _isLoading = true);
      try {
        final address = await widget.geocodingService.reverseGeocode(location);
        if (!mounted) return;

        setState(() {
          _currentAddress = address;
          _selectedLocation = location;
        });
        widget.onAddressPicked(AddressResult(
          address: address,
          coordinates: location,
        ));
      } on AddressPickerException catch (e) {
        widget.onError?.call(e);
      } catch (e) {
        widget.onError?.call(AddressPickerException('Unknown error occurred', e));
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? const AddressPickerTheme();
    final textStyle = theme.addressTextStyle ?? Theme.of(context).textTheme.bodyMedium;

    return Column(
      children: [
        Expanded(
          child: widget.mapProvider.buildMap(
            initialLocation: _selectedLocation,
            onLocationChanged: _updateAddress,
            markerIcon: theme.markerIcon,
            zoom: theme.mapZoom,
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        if (_currentAddress != null)
          Padding(
            padding: theme.padding ?? const EdgeInsets.all(8.0),
            child: Text(
              _currentAddress!,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}