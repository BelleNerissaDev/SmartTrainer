import 'package:SmartTrainer_Personal/components/sections/card_calendario_treinos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('CardCalendarioTreinos Widget Tests', () {
    testWidgets('renders CardCalendarioTreinos correctly',
        (WidgetTester tester) async {
      final DateTime hoje = DateTime(2024, 9, 15);
      final List<DateTime> diasNaoTreinados = [
        DateTime(2024, 9, 10),
        DateTime(2024, 9, 12)
      ];
      final List<DateTime> diasTreinados = [
        DateTime(2024, 9, 11),
        DateTime(2024, 9, 14)
      ];

      await tester.pumpWidget(
        createWidgetUnderTest(
          child: CardCalendarioTreinos(
            hoje: hoje,
            diasNaoTreinados: diasNaoTreinados,
            diasTreinados: diasTreinados,
          ),
        ),
      );

      final monthTitleFinder = find.text('Setembro 2024');
      expect(monthTitleFinder, findsOneWidget);

      final diaNaoTreinadoFinder = find.text('10');
      final diaTreinadoFinder = find.text('11');
      expect(diaNaoTreinadoFinder, findsOneWidget);
      expect(diaTreinadoFinder, findsOneWidget);

      final diaHojeFinder = find.text('15');
      expect(diaHojeFinder, findsOneWidget);
    });

    testWidgets('navigates between months when page is changed',
        (WidgetTester tester) async {
      final DateTime hoje = DateTime(2024, 9, 15);
      final List<DateTime> diasNaoTreinados = [DateTime(2024, 9, 10)];
      final List<DateTime> diasTreinados = [DateTime(2024, 9, 11)];

      await tester.pumpWidget(
        createWidgetUnderTest(
          child: CardCalendarioTreinos(
            hoje: hoje,
            diasNaoTreinados: diasNaoTreinados,
            diasTreinados: diasTreinados,
          ),
        ),
      );

      expect(find.text('Setembro 2024'), findsOneWidget);

      // Inicia o gesto de arrastar para a direita (navegar para Agosto 2024)
      var finder = find.byType(Card);
      var moveBy = const Offset(300.0, 0.0);
      var dragDuration = const Duration(seconds: 1);

      await tester.timedDrag(finder, moveBy, dragDuration);

      await tester.pumpAndSettle();

      expect(find.text('Agosto 2024'), findsOneWidget);
    });
  });
}
