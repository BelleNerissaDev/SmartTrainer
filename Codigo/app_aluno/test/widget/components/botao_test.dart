import 'package:SmartTrainer/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/botao.dart';

void main() {
  group('Botao', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Botao(
              texto: 'Test Button',
              onPressed: () {},
              tipo: TipoBotao.primary,
              colorTheme: CustomTheme.colorFamilyLight,
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('calls onPressed when pressed', (WidgetTester tester) async {
      bool onPressedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Botao(
              texto: 'Test Button',
              onPressed: () {
                onPressedCalled = true;
              },
              tipo: TipoBotao.primary,
              colorTheme: CustomTheme.colorFamilyLight,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(onPressedCalled, true);
    });
  });
}
