import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/models/entity/exercicio.dart';
import 'package:SmartTrainer/models/entity/grupo_muscular.dart';
import 'package:SmartTrainer/models/entity/treino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/card_proximo_treino.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'card_proximo_treino_test.mocks.dart';

@GenerateMocks([Treino, Exercicio, GrupoMuscular])

void main() {
  group('CardProximoTreino', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      final theme = CustomTheme.colorFamilyLight;
      final treino = MockTreino();
      final exercicio = MockExercicio();
      final grupoMuscular = MockGrupoMuscular();

      when(treino.nome).thenReturn('Sample Title');
      when(treino.exercicios).thenReturn([exercicio]);
      when(exercicio.gruposMusculares).thenReturn([grupoMuscular]);
      when(grupoMuscular.nome).thenReturn('Sample Grupo Muscular');
      when(exercicio.nome).thenReturn('Sample Exercicio');
      when(exercicio.gruposMusculares).thenReturn([grupoMuscular]);
      await tester.pumpWidget(
        MaterialApp(
          home: Container(
            child: CardProximoTreino(
              colorTheme: theme,
              treino: treino,
              disponivel: true,
            ),
          ),
        ),
      );

      expect(find.text('Sample Title'), findsOneWidget);
      expect(find.byType(CardProximoTreino), findsOneWidget);
      expect(find.text('Grupos Musculares: '), findsOneWidget);
      expect(find.text(grupoMuscular.nome), findsOneWidget);
      expect(find.byIcon(Mdi.armFlexOutline), findsOneWidget);
      expect(find.text('Iniciar treino'), findsOneWidget);
    });
  });
}
