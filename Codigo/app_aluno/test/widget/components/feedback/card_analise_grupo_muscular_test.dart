import 'package:SmartTrainer/models/entity/exercicio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/feedback/card_analise_grupo_muscular.dart';
import 'package:SmartTrainer/models/entity/grupo_muscular.dart';
import 'package:SmartTrainer/models/entity/treino.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer/config/theme_provider.dart';

void main() {
  group('CardAnaliseGrupoMuscular', () {
    late ThemeProvider themeProvider;

    setUp(() {
      themeProvider = ThemeProvider();
    });

    testWidgets('displays message when no treinos are provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>.value(
          value: themeProvider,
          child: const MaterialApp(
            home: Scaffold(
              body: CardAnaliseGrupoMuscular(
                treinos: [],
                totalTreinos: 0,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Nenhum treino realizado ainda'), findsOneWidget);
    });

    testWidgets('displays tempo and data when showTempo is true',
        (WidgetTester tester) async {
      final grupoMuscular = GrupoMuscular(
        nome: 'Peito',
        id: '',
      );
      final treino = Treino(
        exercicios: [
          Exercicio(
              nome: 'Supino',
              metodologia: MetodologiaExercicio.TRADICIONAL,
              descricao: 'Supino reto com barra',
              carga: 50,
              repeticoes: 10,
              series: 3,
              intervalo: '00:50',
              gruposMusculares: [grupoMuscular])
        ],
        nome: 'Treino A',
      );
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>.value(
          value: themeProvider,
          child: MaterialApp(
            home: Scaffold(
              body: CardAnaliseGrupoMuscular(
                treinos: [treino],
                totalTreinos: 1,
                showTempo: true,
                tempo: 60,
                data: DateTime(2023, 10, 1, 10, 0, 0),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Tempo total: 01:00'), findsOneWidget);
      expect(find.text('10:00:00 - 01-10-2023'), findsOneWidget);
    });

    testWidgets('displays percentage for each grupo muscular',
        (WidgetTester tester) async {
      final grupoMuscular = GrupoMuscular(
        nome: 'Peito',
        id: '',
      );
      final treino = Treino(
        exercicios: [
          Exercicio(
              nome: 'Supino',
              metodologia: MetodologiaExercicio.TRADICIONAL,
              descricao: 'Supino reto com barra',
              carga: 50,
              repeticoes: 10,
              series: 3,
              intervalo: '00:50',
              gruposMusculares: [grupoMuscular])
        ],
        nome: 'Treino A',
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>.value(
          value: themeProvider,
          child: MaterialApp(
            home: Scaffold(
              body: CardAnaliseGrupoMuscular(
                treinos: [treino],
                totalTreinos: 1,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Peito'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
    });
  });
}
