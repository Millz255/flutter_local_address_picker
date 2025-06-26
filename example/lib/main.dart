import 'package:flutter/material.dart';
import 'package:flutter_local_address_picker/flutter_local_address_picker.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Address Picker Demo')),
        body: AddressPicker(
          onAddressPicked: (result) {
            print('Picked: ${result.address}');
            print('Coordinates: ${result.coordinates}');
          },
          theme: const AddressPickerTheme(
            primaryColor: Colors.green,
            mapZoom: 16.0,
          ),
        ),
      ),
    );
  }
}