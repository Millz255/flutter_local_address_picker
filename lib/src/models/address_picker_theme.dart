import 'package:flutter/material.dart';

@immutable
class AddressPickerTheme {
  final Color primaryColor;
  final Widget? markerIcon;
  final double mapZoom;
  final bool showCurrentLocationButton;
  final EdgeInsetsGeometry padding;
  final TextStyle? addressTextStyle;
  final ButtonStyle? buttonStyle;
  final double mapMarkerSize;

  const AddressPickerTheme({
    this.primaryColor = Colors.blue,
    this.markerIcon,
    this.mapZoom = 15.0,
    this.showCurrentLocationButton = true,
    this.padding = const EdgeInsets.all(8.0),
    this.addressTextStyle,
    this.buttonStyle,
    this.mapMarkerSize = 40.0,
  })  : assert(mapZoom >= 1 && mapZoom <= 20, 'Zoom must be between 1-20'),
        assert(mapMarkerSize > 0, 'Marker size must be positive');

  AddressPickerTheme copyWith({
    Color? primaryColor,
    Widget? markerIcon,
    double? mapZoom,
    bool? showCurrentLocationButton,
    EdgeInsetsGeometry? padding,
    TextStyle? addressTextStyle,
    ButtonStyle? buttonStyle,
    double? mapMarkerSize,
  }) {
    return AddressPickerTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      markerIcon: markerIcon ?? this.markerIcon,
      mapZoom: mapZoom ?? this.mapZoom,
      showCurrentLocationButton: showCurrentLocationButton ?? this.showCurrentLocationButton,
      padding: padding ?? this.padding,
      addressTextStyle: addressTextStyle ?? this.addressTextStyle,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      mapMarkerSize: mapMarkerSize ?? this.mapMarkerSize,
    );
  }

  AddressPickerTheme merge(AddressPickerTheme? other) {
    if (other == null) return this;
    return copyWith(
      primaryColor: other.primaryColor,
      markerIcon: other.markerIcon,
      mapZoom: other.mapZoom,
      showCurrentLocationButton: other.showCurrentLocationButton,
      padding: other.padding,
      addressTextStyle: other.addressTextStyle,
      buttonStyle: other.buttonStyle,
      mapMarkerSize: other.mapMarkerSize,
    );
  }

  static AddressPickerTheme of(BuildContext context) {
    final inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedAddressPickerTheme>();
    return inheritedTheme?.theme ??
           const AddressPickerTheme().merge(Theme.of(context).extension<AddressPickerTheme>());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddressPickerTheme &&
           other.primaryColor == primaryColor &&
           other.markerIcon == markerIcon &&
           other.mapZoom == mapZoom &&
           other.showCurrentLocationButton == showCurrentLocationButton &&
           other.padding == padding &&
           other.addressTextStyle == addressTextStyle &&
           other.buttonStyle == buttonStyle &&
           other.mapMarkerSize == mapMarkerSize;
  }

  @override
  int get hashCode => Object.hash(
    primaryColor,
    markerIcon,
    mapZoom,
    showCurrentLocationButton,
    padding,
    addressTextStyle,
    buttonStyle,
    mapMarkerSize,
  );
}

extension ThemeDataExtensions on ThemeData {
  AddressPickerTheme? get addressPickerTheme => extension<AddressPickerTheme>();
}

extension AddressPickerThemeExtension on BuildContext {
  AddressPickerTheme get addressPickerTheme => AddressPickerTheme.of(this);
}

class _InheritedAddressPickerTheme extends InheritedWidget {
  final AddressPickerTheme theme;

  const _InheritedAddressPickerTheme({
    required this.theme,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedAddressPickerTheme oldWidget) =>
      theme != oldWidget.theme;
}
