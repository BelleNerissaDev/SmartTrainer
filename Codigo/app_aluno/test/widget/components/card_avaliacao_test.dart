import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/card_avaliacao.dart';
import 'package:SmartTrainer/models/entity/avaliacao_fisica.dart';
import 'package:SmartTrainer/app_theme.dart';

void main() {
  group('CardAvaliacao Widget Tests', () {
    late AvaliacaoFisica avaliacao;
    late MyColorFamily colorTheme;

    setUp(() {
      avaliacao = AvaliacaoFisica(
        data: DateTime(2021, 1, 1),
        tipoAvaliacao: TipoAvaliacao.online,
        status: StatusAvaliacao.realizada,
        imc: 22.0,
        percentualGordura: 15.0,
        relacaoCinturaQuadril: 0.85,
        pesoGordura: 10.0,
      );
      colorTheme = CustomTheme.colorFamilyLight;
    });

    testWidgets('displays the correct icon and date for online avaliacao',
        (WidgetTester tester) async {
      avaliacao.tipoAvaliacao = TipoAvaliacao.online;
      await tester.pumpWidget(
        MaterialApp(
          home: CardAvaliacao(
            avaliacao: avaliacao,
            colorTheme: colorTheme,
            isExpanded: false,
            onTap: () {},
            action: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.language), findsOneWidget);
      expect(find.text('Avaliação 01-01-2021'), findsOneWidget);
    });
    testWidgets('displays the correct icon and date for pdf avaliacao',
        (WidgetTester tester) async {
      avaliacao.tipoAvaliacao = TipoAvaliacao.pdf;
      await tester.pumpWidget(
        MaterialApp(
          home: CardAvaliacao(
            avaliacao: avaliacao,
            colorTheme: colorTheme,
            isExpanded: false,
            onTap: () {},
            action: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.picture_as_pdf), findsOneWidget);
      expect(find.text('01-01-2021'), findsOneWidget);
    });

    testWidgets('expands and shows additional information when tapped',
        (WidgetTester tester) async {
      bool isExpanded = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  Expanded(
                    child: CardAvaliacao(
                      avaliacao: avaliacao,
                      colorTheme: colorTheme,
                      isExpanded: isExpanded,
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      action: () {},
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );

      expect(find.text('IMC:'), findsNothing);

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();

      expect(find.text('IMC:'), findsOneWidget);
      expect(find.text(' 22.00'), findsOneWidget);
      expect(find.text('Percentual de gordura:'), findsOneWidget);
      expect(find.text('15.00%'), findsOneWidget);
      expect(find.text('Relação cintura-quadril:'), findsOneWidget);
      expect(find.text(' 0.85'), findsOneWidget);
      expect(find.text('Peso de gordura:'), findsOneWidget);
      expect(find.text(' 10.00kg'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    });
  });
}
