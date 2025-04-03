import 'package:SmartTrainer_Personal/components/cards/exercicio_card.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/inputs/search_bar.dart'
    as custom;
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';
import 'package:SmartTrainer_Personal/pages/widgets/exercicios_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/novo_exercicio_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  late List<Exercicio> mockExercicios;
  late List<GrupoMuscular> mockGrupoMusculares;

  setUp(() async {
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
          GrupoMuscular(id: 'perna', nome: 'Perna'),
        ],
      ),
    ];

    mockGrupoMusculares = [
      GrupoMuscular(id: 'peitoral', nome: 'Peitoral'),
      GrupoMuscular(id: 'perna', nome: 'Perna'),
      GrupoMuscular(id: 'costas', nome: 'Costas')
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
        routes: {
          RoutesNames.novoExercicio.route: (context) =>
              const NovoExercicioPage(),
          // Adicione outras rotas necessárias para o teste aqui
        },
      ),
    );
  }

  group('ExerciciosPage Widget Tests', () {
    testWidgets('renders ExerciciosPage correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
          child: ExerciciosPage(
        exerciciosOnTest: Future.value(mockExercicios),
        gruposOnTest: Future.value(mockGrupoMusculares),
      )));

      await tester.pumpAndSettle();

      // Verifica se o AppBar personalizado está sendo exibido
      expect(find.byType(CustomAppBar), findsOneWidget);

      // Verifica se o HeaderContainer está presente com o título correto
      expect(find.byType(HeaderContainer), findsOneWidget);
      expect(find.text('Exercícios'), findsOneWidget);

      // Verifica a presença do CardContainer
      expect(find.byType(CardContainer), findsOneWidget);

      // Verifica a presença da SearchBar
      expect(find.byType(custom.SearchBar), findsOneWidget);

      // Verifica se os exercícios estão sendo exibidos
      expect(find.byType(ExercicioCard), findsNWidgets(2));

      // Verifica os nomes dos exercícios
      expect(find.text('Supino Reto'), findsOneWidget);
      expect(find.text('Agachamento'), findsOneWidget);

      // Verifica se o FloatingActionButton está presente
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('filters exercises by grupo muscular',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: ExerciciosPage(
          exerciciosOnTest: Future.value(mockExercicios),
          gruposOnTest: Future.value(mockGrupoMusculares),
        ),
      ));

      await tester.pumpAndSettle();

      // Encontra e toca no chip de filtro 'Peitoral'
      final peitoralChip = find.widgetWithText(FilterChip, 'Peitoral');
      await tester.longPress(peitoralChip);
      await tester.pumpAndSettle();

      // Verifica se apenas o exercício de peitoral está visível
      expect(find.text('Supino Reto'), findsOneWidget);
      expect(find.text('Agachamento'), findsNothing);

      // Toca novamente para remover o filtro
      await tester.longPress(peitoralChip);
      await tester.pumpAndSettle();

      // Verifica se todos os exercícios estão visíveis novamente
      expect(find.text('Supino Reto'), findsOneWidget);
      expect(find.text('Agachamento'), findsOneWidget);
    });

    testWidgets('search exercises by name', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: ExerciciosPage(
          exerciciosOnTest: Future.value(mockExercicios),
          gruposOnTest: Future.value(mockGrupoMusculares),
        ),
      ));

      await tester.pumpAndSettle();

      // Encontra o SearchBar e digita 'Supino'
      final searchBar = find.byType(custom.SearchBar);
      await tester.enterText(searchBar, 'Supino');
      await tester.pumpAndSettle();

      // Verifica se apenas o exercício 'Supino Reto' está visível
      expect(find.text('Supino Reto'), findsOneWidget);
      expect(find.text('Agachamento'), findsNothing);

      // Limpa a pesquisa
      await tester.enterText(searchBar, '');
      await tester.pumpAndSettle();

      // Verifica se todos os exercícios estão visíveis novamente
      expect(find.text('Supino Reto'), findsOneWidget);
      expect(find.text('Agachamento'), findsOneWidget);
    });

    testWidgets('navigates to novo exercicio page',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: ExerciciosPage(
          exerciciosOnTest: Future.value(mockExercicios),
          gruposOnTest: Future.value(mockGrupoMusculares),
        ),
      ));

      await tester.pumpAndSettle();

      // Encontra e toca no FloatingActionButton
      final fab = find.byType(FloatingActionButton);
      await tester.longPress(fab);
      await tester.pumpAndSettle();

      expect(find.byType(NovoExercicioPage), findsOneWidget);
    });
  });
}
