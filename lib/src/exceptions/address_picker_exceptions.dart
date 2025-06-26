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

class ApiKeyMissingException extends AddressPickerException {
  const ApiKeyMissingException()
      : super('API key is required for this provider');
}