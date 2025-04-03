import 'package:SmartTrainer/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/card_login_semanal.dart';

void main() {
  testWidgets('CardLoginSemanal displays the correct text',
      (WidgetTester tester) async {
    final theme = CustomTheme.colorFamilyLight;
    await tester.pumpWidget(
      MaterialApp(
          home: Container(
        child: CardLoginSemanal(
          colorTheme: theme,
          diaSemana: 3,
          acessos: 7,
        ),
      )),
    );

    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(RichText), findsOneWidget);
    expect(find.byType(CardLoginSemanal), findsOneWidget);
  });
}
