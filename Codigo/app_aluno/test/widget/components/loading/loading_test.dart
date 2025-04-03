import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/loading/loading.dart';

void main() {
  group('Loading', () {
    testWidgets('showLoading displays CircularProgressIndicator',
        (WidgetTester tester) async {
      // Create a test key.
      final testKey = const Key('testKey');

      // Build the widget tree.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  key: testKey,
                  onPressed: () {
                    showLoading(context);
                  },
                  child: const Text('Show Loading'),
                );
              },
            ),
          ),
        ),
      );

      // Tap the button to show the loading indicator.
      await tester.tap(find.byKey(testKey));
      await tester.pump(); // Start the animation.

      // Verify if CircularProgressIndicator is displayed.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('showLoading is dismissed when Navigator.pop is called',
        (WidgetTester tester) async {
      // Create a test key.
      final testKey = const Key('testKey');

      // Build the widget tree.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  key: testKey,
                  onPressed: () {
                    showLoading(context);
                  },
                  child: const Text('Show Loading'),
                );
              },
            ),
          ),
        ),
      );

      // Tap the button to show the loading indicator.
      await tester.tap(find.byKey(testKey));
      await tester.pump(); // Start the animation.

      // Verify if CircularProgressIndicator is displayed.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Dismiss the loading indicator.
      Navigator.of(tester.element(find.byType(ElevatedButton))).pop();
      await tester.pump(); // Complete the animation.

      // Verify if CircularProgressIndicator is dismissed.
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
