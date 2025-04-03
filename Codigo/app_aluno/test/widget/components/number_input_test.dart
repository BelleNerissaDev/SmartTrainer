import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/number_input.dart';
import 'package:SmartTrainer/utils/error_message.dart';
import 'package:SmartTrainer/app_theme.dart';

void main() {
  group('NumberInputField', () {
    late TextEditingController controller;
    late MyColorFamily colorTheme;

    setUp(() {
      controller = TextEditingController();
      colorTheme = CustomTheme.colorFamilyLight;
    });

    testWidgets('displays label and hint text', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: NumberInputField(
            label: 'Enter number',
            colorTheme: colorTheme,
            controller: controller,
          ),
        ),
      ));

      expect(find.text('Enter number'), findsNWidgets(2));
    });

    testWidgets('displays error message when showErrors is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: NumberInputField(
            label: 'Enter number',
            colorTheme: colorTheme,
            controller: controller,
            errors: [ErrorMessage(error: true, message: 'Invalid number')],
            showErrors: true,
          ),
        ),
      ));

      expect(find.text('Invalid number'), findsOneWidget);
    });

    testWidgets('does not display error message when showErrors is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: NumberInputField(
            label: 'Enter number',
            colorTheme: colorTheme,
            controller: controller,
            errors: [ErrorMessage(error: true, message: 'Invalid number')],
            showErrors: false,
          ),
        ),
      ));

      expect(find.text('Invalid number'), findsNothing);
    });

    testWidgets('updates controller text', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: NumberInputField(
            label: 'Enter number',
            colorTheme: colorTheme,
            controller: controller,
          ),
        ),
      ));

      await tester.enterText(find.byType(TextField), '123');
      expect(controller.text, '123');
    });
  });
}
