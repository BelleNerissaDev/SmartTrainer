import 'package:SmartTrainer_Personal/components/sections/grupo_muscular_page/list_exercicios_tile.dart';
import 'package:SmartTrainer_Personal/components/sections/grupo_muscular_page/list_todos_exercicios_builder.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';
import 'package:SmartTrainer_Personal/pages/widgets/grupo_muscular.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/components/inputs/search_bar.dart'
    as custom;
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  late GrupoMuscular mockGrupoMusculares;
  late List<Exercicio> mockExercicios;
  late List<Exercicio> mockExerciciosAssociados;

  setUp(() {
    mockGrupoMusculares = GrupoMuscular(id: 'peitoral', nome: 'Peitoral');
    mockExercicios = [
      Exercicio(
        id: '1',
        nome: 'Supino Reto',
        metodologia: MetodologiaExercicio.TRADICIONAL,
        descricao: 'Exercício para peitoral',
        carga: 20.0,
        repeticoes: 12,
        series: 3,
        intervalo: '45:00',
        gruposMusculares: [
          GrupoMuscular(id: 'peitoral', nome: 'Peitoral'),
        ],
      ),
      Exercicio(
        id: '2',
        nome: 'Agachamento',
        metodologia: MetodologiaExercicio.TRADICIONAL,
        descricao: 'Exercício para pernas',
        carga: 40.0,
        repeticoes: 10,
        series: 4,
        intervalo: '60:00',
        gruposMusculares: [
          GrupoMuscular(id: 'peitoral', nome: 'Peitoral'),
        ],
      ),
      Exercicio(
        id: '3',
        nome: 'Rosca Direta',
        metodologia: MetodologiaExercicio.TRADICIONAL,
        descricao: 'Exercício para biceps',
        carga: 40.0,
        repeticoes: 10,
        series: 4,
        intervalo: '60:00',
        gruposMusculares: [
          GrupoMuscular(id: 'peitoral', nome: 'Peitoral'),
        ],
      ),
    ];
    mockExerciciosAssociados = [
      mockExercicios.first,
      mockExercicios.last,
    ];
  });

  Widget createWidgetUnderTest({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('GruposMuscularesPage Widget Tests', () {
    testWidgets('renders all exercices with icons and names',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: GrupoMuscularPage(
          grupoMuscularOnTest: mockGrupoMusculares,
          exerciciosOnTest: Future.value(mockExercicios),
          exerciciosAssOnTest: Future.value(mockExerciciosAssociados),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(ListExerciciosTile), findsOneWidget);
      expect(find.textContaining('Agachamento'), findsOneWidget);

      await tester.pumpAndSettle();
      var finder = find.byType(custom.SearchBar);
      var moveBy = const Offset(0, -400);
      var dragDuration = const Duration(seconds: 1);

      await tester.timedDrag(finder, moveBy, dragDuration, warnIfMissed: false);

      expect(find.byType(ListTodosExerciciosBuilder), findsOneWidget);

      expect(find.textContaining('Supino Reto'), findsOneWidget);
      expect(find.textContaining('Rosca Direta'), findsOneWidget);
    });
  });
}
