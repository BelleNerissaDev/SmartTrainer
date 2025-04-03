import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/treinos/card_treinos.dart';
import 'package:SmartTrainer/models/entity/grupo_muscular.dart';
import 'package:SmartTrainer/app_theme.dart';

void main() {
  group('CardTreinos', () {
    final colorTheme = CustomTheme.colorFamilyLight;
    final gruposMusculares = [
      GrupoMuscular(nome: 'Peito', id: '1'),
      GrupoMuscular(nome: 'Costas', id: '2'),
    ];
    testWidgets('CardTreinos displays title and muscle groups',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardTreinos(
              colorTheme: colorTheme,
              titulo: 'Treino A',
              gruposMusculares: gruposMusculares,
              iniciarTreino: () {},
            ),
          ),
        ),
      );

      expect(find.text('Treino A'), findsOneWidget);
      expect(find.text('Peito'), findsOneWidget);
      expect(find.text('Costas'), findsOneWidget);
      expect(find.text('Iniciar treino'), findsOneWidget);
    });

    testWidgets('CardTreinos button is enabled when disponivel is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardTreinos(
              colorTheme: colorTheme,
              titulo: 'Treino A',
              gruposMusculares: gruposMusculares,
              iniciarTreino: () {},
              disponivel: true,
            ),
          ),
        ),
      );

      final button = find.byType(ElevatedButton);
      expect(button, findsOneWidget);
      expect(tester.widget<ElevatedButton>(button).enabled, isTrue);
    });

    testWidgets('CardTreinos button is disabled when disponivel is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardTreinos(
              colorTheme: colorTheme,
              titulo: 'Treino A',
              gruposMusculares: gruposMusculares,
              iniciarTreino: () {},
              disponivel: false,
            ),
          ),
        ),
      );

      final button = find.byType(ElevatedButton);
      expect(button, findsOneWidget);
      expect(tester.widget<ElevatedButton>(button).enabled, isFalse);
    });
  });
}
