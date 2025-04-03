import 'package:SmartTrainer/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/card_calendario_treinos.dart';

void main() {
  group('CardCalendarioTreinos', () {
    testWidgets('Widget has correct title', (WidgetTester tester) async {
      final theme = CustomTheme.colorFamilyLight;
      await tester.pumpWidget(
        MaterialApp(
          home: CardCalendarioTreinos(
            hoje: DateTime.now(),
            diasNaoTreinados: [],
            diasTreinados: [],
            colorTheme: theme,
          ),
        ),
      );

      final titleFinder = find.text('Calendário de Treinos');
      expect(titleFinder, findsOneWidget);
    });
  });
}
