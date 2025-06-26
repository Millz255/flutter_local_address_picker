import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_address_picker/flutter_local_address_picker.dart';

void main() {
  testWidgets('AddressPicker widget exists', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AddressPicker(
            onAddressPicked: (address) {},
          ),
        ),
      ),
    );

    expect(find.byType(AddressPicker), findsOneWidget);
  });
}
