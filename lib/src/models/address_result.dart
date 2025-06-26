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