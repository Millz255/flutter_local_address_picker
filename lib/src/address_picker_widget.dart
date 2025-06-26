class AddressPicker extends StatefulWidget {
  final ValueChanged<AddressResult> onAddressPicked;
  final MapProvider mapProvider;
  final GeocodingService geocodingService;
  final AddressPickerTheme? theme;

  const AddressPicker({
    Key? key,
    required this.onAddressPicked,
    this.mapProvider = MapProvider.openStreetMap,
    this.geocodingService = const NominatimService(),
    this.theme,
  }) : super(key: key);

  @override
  _AddressPickerState createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
  LatLng? _selectedLocation;
  String? _currentAddress;
  bool _isLoading = false;

  Future<void> _updateAddress(LatLng location) async {
    setState(() => _isLoading = true);
    try {
      final address = await widget.geocodingService.reverseGeocode(location);
      setState(() {
        _currentAddress = address;
        _selectedLocation = location;
      });
      widget.onAddressPicked(AddressResult(
        address: address,
        coordinates: location,
      ));
    } catch (e) {

    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: widget.mapProvider.buildMap(
            initialLocation: _selectedLocation,
            onLocationChanged: _updateAddress,
            markerIcon: widget.theme?.markerIcon,
          ),
        ),
        if (_isLoading) CircularProgressIndicator(),
        if (_currentAddress != null) 
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(_currentAddress!),
          ),
      ],
    );
  }
}