// ignore_for_file: unused_local_variable, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dark Theme', () {
    testWidgets('button should work', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: ElevatedButton(
        onPressed: () {},
        child: const Text('Settings'),
      )));
      await tester.tap(find.text("Settings"));
      await tester.pump();
      expect(find.text('Settings'), findsOneWidget);
    });
  });
}
