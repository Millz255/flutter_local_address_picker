import 'package:collection/collection.dart'; 

class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LatLng &&
           other.latitude == latitude &&
           other.longitude == longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);
}

class AddressResult {
  final String address;
  final LatLng coordinates;
  final Map<String, dynamic>? addressComponents;

  const AddressResult({
    required this.address,
    required this.coordinates,
    this.addressComponents,
  }) : assert(address.isNotEmpty, 'Address cannot be empty');

  AddressResult copyWith({
    String? address,
    LatLng? coordinates,
    Map<String, dynamic>? addressComponents,
  }) {
    return AddressResult(
      address: address ?? this.address,
      coordinates: coordinates ?? this.coordinates,
      addressComponents: addressComponents ?? this.addressComponents,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
      if (addressComponents != null) 'components': addressComponents,
    };
  }

  factory AddressResult.fromMap(Map<String, dynamic> map) {
    return AddressResult(
      address: map['address'] as String,
      coordinates: LatLng(
        map['latitude'] as double,
        map['longitude'] as double,
      ),
      addressComponents: map['components'] as Map<String, dynamic>?,
    );
  }

  @override
  String toString() {
    return 'AddressResult(address: $address, coordinates: $coordinates)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddressResult &&
           other.address == address &&
           other.coordinates == coordinates &&
           mapEquals(other.addressComponents, addressComponents);
  }

  @override
  int get hashCode => Object.hash(
    address,
    coordinates,
    addressComponents,
  );
}
