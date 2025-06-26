class AddressPickerTheme {
  final Color primaryColor;
  final Widget? markerIcon;
  final double mapZoom;
  final bool showCurrentLocationButton;

  const AddressPickerTheme({
    this.primaryColor = Colors.blue,
    this.markerIcon,
    this.mapZoom = 15.0,
    this.showCurrentLocationButton = true,
  });
}