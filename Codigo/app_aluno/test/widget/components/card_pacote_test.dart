import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/card_pacote.dart';
import 'package:SmartTrainer/app_theme.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';

void main() {
  testWidgets('CardPacote displays correct values',
      (WidgetTester tester) async {
    const double valor = 99.99;
    const int acessos = 10;
    final MyColorFamily colorTheme = CustomTheme.colorFamilyLight;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CardPacote(
            valor: valor,
            acessos: acessos,
            colorTheme: colorTheme,
          ),
        ),
      ),
    );

    expect(find.text('Pacote'), findsOneWidget);
    expect(find.byIcon(Mdi.packageVariantClosed), findsOneWidget);
    expect(find.text('Valor (mês): R\$ 99.99'), findsOneWidget);
    expect(find.text('Número de acessos (mês): 10'), findsOneWidget);
  });
}
