import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/sections/info_aluno_avaliacoes.dart';
import 'package:SmartTrainer_Personal/models/entity/avaliacao_fisica.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  late List<AvaliacaoFisica> avaliacoes;

  setUp(() {
    avaliacoes = [
      AvaliacaoFisica(
          data: DateTime.now(),
          tipoAvaliacao: TipoAvaliacao.pdf,
          status: StatusAvaliacao.realizada),
      AvaliacaoFisica(
        data: DateTime.now(),
        tipoAvaliacao: TipoAvaliacao.online,
        status: StatusAvaliacao.realizada,
        imc: 22.6,
        percentualGordura: 18.3,
        relacaoCinturaQuadril: 0.98,
        pesoGordura: 8,
      ),
    ];
  });

  group('AlunoAvaliacoesInfo Widget Tests', () {
    testWidgets('renders AlunoAvaliacoesInfo correctly with mock data',
        (WidgetTester tester) async {
      

      var colorTheme = CustomTheme.colorFamilyLight;

      await tester.pumpWidget(createWidgetUnderTest(
        child: InfoAlunoAvaliacoes(
          colorTheme: colorTheme,
          avaliacoes: avaliacoes,
          solicitarAction: () {},
          enviarAction: () {},
        ),
      ));

      expect(find.text('Avaliações Físicas'), findsOneWidget);

      expect(find.text('Solicitar'), findsOneWidget);
      expect(find.text('Enviar'), findsOneWidget);
    });

    testWidgets('expands and collapses online evaluation details',
        (WidgetTester tester) async {
      

      var colorTheme = CustomTheme.colorFamilyLight;

      await tester.pumpWidget(createWidgetUnderTest(
        child: InfoAlunoAvaliacoes(
          colorTheme: colorTheme,
          avaliacoes: avaliacoes,
          solicitarAction: () {},
          enviarAction: () {},
        ),
      ));

      expect(find.text('IMC:'), findsNothing);
      expect(find.text('Percentual de gordura:'), findsNothing);

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();

      expect(find.text('IMC:'), findsOneWidget);
      expect(find.text('Percentual de gordura:'), findsOneWidget);
      expect(find.text('Relação cintura-quadril:'), findsOneWidget);
      expect(find.text('Peso de gordura:'), findsOneWidget);

      expect(find.textContaining('22.6'), findsOneWidget);
      expect(find.textContaining('18.30%'), findsOneWidget);
      expect(find.textContaining('0.98'), findsOneWidget);
      expect(find.textContaining('8.00kg'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
      await tester.pumpAndSettle();

      expect(find.text('IMC:'), findsNothing);
      expect(find.text('Percentual de gordura:'), findsNothing);
    });
  });
}
