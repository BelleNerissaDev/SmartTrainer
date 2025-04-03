import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/card_medidas.dart';
import 'package:SmartTrainer/app_theme.dart';
import 'package:ionicons/ionicons.dart';

void main() {
  testWidgets('CardMedidas displays correct measurements',
      (WidgetTester tester) async {
    const pescoco = 40;
    const cintura = 80;
    const quadril = 100;
    final colorTheme = CustomTheme.colorFamilyLight;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CardMedidas(
            pescoco: pescoco,
            cintura: cintura,
            quadril: quadril,
            colorTheme: colorTheme,
          ),
        ),
      ),
    );

    expect(find.text('Pescoço: $pescoco cm'), findsOneWidget);
    expect(find.text('Cintura: $cintura cm'), findsOneWidget);
    expect(find.text('Quadril: $quadril cm'), findsOneWidget);
    expect(find.text('Medidas corporais'), findsOneWidget);
    expect(find.byIcon(Ionicons.body), findsOneWidget);
  });

  testWidgets('CardMedidas uses correct colors from theme',
      (WidgetTester tester) async {
    const pescoco = 40;
    const cintura = 80;
    const quadril = 100;
    final colorTheme = CustomTheme.colorFamilyLight;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CardMedidas(
            pescoco: pescoco,
            cintura: cintura,
            quadril: quadril,
            colorTheme: colorTheme,
          ),
        ),
      ),
    );

    final icon = tester.widget<Icon>(find.byIcon(Ionicons.body));
    final textStyle = tester.widget<Text>(find.text('Medidas corporais')).style;

    expect(icon.color, colorTheme.indigo_primary_700);
    expect(textStyle?.color, colorTheme.black_onSecondary_100);
  });
}
