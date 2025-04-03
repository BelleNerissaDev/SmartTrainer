import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/card_email_telefone.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';

void main() {
  testWidgets('CardEmailTelefone displays email and telefone correctly',
      (WidgetTester tester) async {
    const testEmail = 'test@example.com';
    const testTelefone = '123456789';
    final testColorTheme = CustomTheme.colorFamilyLight;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CardEmailTelefone(
            colorTheme: testColorTheme,
            email: testEmail,
            telefone: testTelefone,
          ),
        ),
      ),
    );

    // Verify if the telefone is displayed correctly
    expect(find.text(testTelefone), findsOneWidget);
    expect(find.byIcon(Mdi.phone), findsOneWidget);

    // Verify if the email is displayed correctly
    expect(find.text(testEmail), findsOneWidget);
    expect(find.byIcon(Mdi.emailOutline), findsOneWidget);

    // Verify if the Divider is displayed
    expect(find.byType(Divider), findsOneWidget);
  });
}
