import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';
import 'package:SmartTrainer_Personal/pages/widgets/novo_exercicio_do_plano.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('NovoExercicioDoPlanoPage', () {
    final Exercicio exercicio = Exercicio(
      nome: 'Exercicio Teste',
      descricao: 'Descricao Teste',
      metodologia: MetodologiaExercicio.TRADICIONAL,
      carga: 50,
      tipoCarga: 'kg',
      repeticoes: 10,
      series: 3,
      intervalo: '00:30',
      gruposMusculares: [GrupoMuscular(id: '1', nome: 'Grupo Teste')],
    );

    testWidgets('NovoExercicioDoPlano renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: NovoExercicioDoPlano(
          exercicioOnTest: exercicio,
        ),
      ));

      expect(find.text('Novo Exercício'), findsOneWidget);
      expect(find.text('Imagem'), findsOneWidget);
      expect(find.text('Metodologia do exercício (Padrão)'), findsOneWidget);
      expect(find.text('Carga (Padrão)'), findsOneWidget);
      expect(find.text('Tipo de Carga'), findsOneWidget);
      expect(find.text('Repetições (Padrão)'), findsOneWidget);
      expect(find.text('Séries (Padrão)'), findsOneWidget);
      expect(find.text('Tempo de Descanso (Padrão)'), findsOneWidget);
      expect(find.text('Grupos musculares'), findsOneWidget);
      expect(find.text('Descrição'), findsOneWidget);
      expect(find.text('URL do Vídeo (YouTube)'), findsOneWidget);
    });

    testWidgets('NovoExercicioDoPlano updates controllers',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: NovoExercicioDoPlano(
          exercicioOnTest: exercicio,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text(exercicio.nome), findsOneWidget);

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(7));

      final cargaField = tester.widget<TextField>(textFields.at(0));
      expect(cargaField.controller!.text, exercicio.carga.toString());
      final tipoCargaField = tester.widget<TextField>(textFields.at(1));
      expect(tipoCargaField.controller!.text, exercicio.tipoCarga);
      final repeticoesField = tester.widget<TextField>(textFields.at(2));
      expect(repeticoesField.controller!.text, exercicio.repeticoes.toString());
      final seriesField = tester.widget<TextField>(textFields.at(3));
      expect(seriesField.controller!.text, exercicio.series.toString());
      final intervaloField = tester.widget<TextField>(textFields.at(4));
      expect(intervaloField.controller!.text, exercicio.intervalo);
      final descricaoField = tester.widget<TextField>(textFields.at(5));
      expect(descricaoField.controller!.text, exercicio.descricao);
    });

    testWidgets('NovoExercicioDoPlano handles image selection',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: NovoExercicioDoPlano(
          exercicioOnTest: exercicio,
        ),
      ));

      await tester.tap(find.byIcon(Icons.add_a_photo));
      await tester.pump();

      expect(find.text('Câmera'), findsOneWidget);
      expect(find.text('Galeria'), findsOneWidget);
    });
  });
}
