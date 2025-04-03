import 'package:SmartTrainer/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/card_infos_pessoais.dart';

void main() {
  testWidgets('CardInfosPessoais displays correct personal information',
      (WidgetTester tester) async {
    final int idade = 25;
    final double peso = 70.5;
    final int altura = 175;
    final cardInfosPessoais = CardInfosPessoais(
      idade: idade,
      peso: peso,
      altura: altura,
      colorTheme: CustomTheme.colorFamilyLight,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Container(
          child: cardInfosPessoais,
        ),
      ),
    );

    expect(find.text('Informações pessoais'), findsOneWidget);
    expect(find.text('Idade: $idade anos'), findsOneWidget);
    expect(find.text('Altura: $altura cm'), findsOneWidget);
    expect(find.text('Peso: $peso kg'), findsOneWidget);
  });
}
