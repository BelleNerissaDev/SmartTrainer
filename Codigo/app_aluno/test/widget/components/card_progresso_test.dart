import 'package:SmartTrainer/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/card_progresso.dart';

void main() {
  testWidgets('CardProgresso displays correct progress',
      (WidgetTester tester) async {
    final int sessoesRealizadas = 5;
    final int sessoesTotais = 10;
    final cardProgresso = CardProgresso(
      sessoesRealizadas: sessoesRealizadas,
      sessoesTotais: sessoesTotais,
      colorTheme: CustomTheme.colorFamilyLight,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Container(
          child: cardProgresso,
        ),
      ),
    );

    expect(find.text('Progresso'), findsOneWidget);
    expect(
        find.text('Sessões: $sessoesRealizadas/$sessoesTotais',
            findRichText: true),
        findsOneWidget);
    expect(
        find.text(
            '${(sessoesRealizadas / sessoesTotais * 100).toStringAsFixed(0)}%'),
        findsOneWidget);
  });
}
