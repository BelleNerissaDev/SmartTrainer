import 'package:SmartTrainer_Personal/components/container/plano_expansion_tile.dart';
import 'package:SmartTrainer_Personal/components/container/treino_expansion_tile.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer_Personal/connections/repository/exercicio_generico_repository.dart';
import 'package:SmartTrainer_Personal/connections/repository/plano_treinos_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:SmartTrainer_Personal/models/entity/plano.dart';
import 'package:SmartTrainer_Personal/models/entity/sexo.dart';
import 'package:SmartTrainer_Personal/models/entity/treino.dart';
import 'package:SmartTrainer_Personal/pages/widgets/aluno_planos_treino.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirestore extends Mock implements FirebaseFirestore {}

void main() {
  group('AlunoPlanosTreino Widget Tests', () {
    late FakeFirebaseFirestore instance;
    late ThemeProvider themeProvider;
    late Aluno mockAluno;
    late PlanoTreino mockPlanoTreino;
    late Treino mockTreino;
    late Exercicio mockExercicio;
    late FakeFirebaseFirestore fakeFirestore;
    late ExercicioGenericoRepository exercicioRepository;
    late PlanoTreinoRepository planoTreinoRepository;
    late AlunoRepository alunoRepository;

    setUp(() async {
      // Initialize providers and mocks
      instance = FakeFirebaseFirestore();
      themeProvider = ThemeProvider();
      fakeFirestore = FakeFirebaseFirestore();

      exercicioRepository =
          ExercicioGenericoRepository(firestore: fakeFirestore);
      planoTreinoRepository = PlanoTreinoRepository(firestore: instance);
      alunoRepository = AlunoRepository(firestore: instance);

      final grupoMuscular = GrupoMuscular(id: '1', nome: 'Peito');

      // Create mock exercicio
      mockExercicio = Exercicio(
        id: '4',
        nome: 'Supino',
        descricao: 'Exercicio de peito',
        carga: 20.0,
        intervalo: '1:00',
        repeticoes: 10,
        series: 3,
        gruposMusculares: [grupoMuscular],
        metodologia: MetodologiaExercicio.TRADICIONAL,
        tipoCarga: 'kg',
        videoUrl: 'https://example.com/video',
        imagem: null,
      );

      await exercicioRepository.create(mockExercicio);

      // Create mock treino with exercicio
      mockTreino = Treino(
        id: '3',
        nome: 'Treino A',
        exercicios: [mockExercicio],
      );

      // Create mock plano with treino
      mockPlanoTreino = PlanoTreino(
        id: '2',
        nome: 'Plano Iniciante',
        // Colocar status no plano como enum e n string (copia anamnese)
        status: 'Ativo',
        treinos: [mockTreino],
      );

      // Create mock aluno
      mockAluno = Aluno(
        id: '1',
        nome: 'John Doe',
        email: 'john.doe@example.com',
        telefone: '123456789',
        dataNascimento: DateTime(1990, 5, 30),
        peso: 70,
        altura: 175,
        imagem: null,
        sexo: Sexo.masculino.toString(),
        primeiroAcesso: false,
        status: StatusAlunoEnum.ATIVO,
        uid: '',
        pacote: Pacote(
          nome: 'teste',
          valorMensal: '200.00',
          numeroAcessos: '20',
        ),
      );
      final alunoDocument = await alunoRepository.create(mockAluno);
      final alunoId = alunoDocument.id;

      await planoTreinoRepository.createPlanoTreinos(
          plano: mockPlanoTreino, alunoId: alunoId!);
    });

    testWidgets('renders AlunoPlanosTreino correctly with plans',
        (WidgetTester tester) async {
      // Build widget
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => themeProvider,
            ),
          ],
          child: MaterialApp(
            home: AlunoPlanosTreino(
              alunoOnTest: Future.value(mockAluno),
              exerciciosOnTest: Future.value([mockExercicio]),
              planosOnTest: Future.value([mockPlanoTreino]),
            ),
          ),
        ),
      );

      // Wait for all animations to complete
      await tester.pumpAndSettle();

      // Verify basic widgets are present
      expect(find.byType(AlunoPlanosTreino), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);

      // Verify PlanoExpansionTile is present
      expect(find.byType(PlanoExpansionTile), findsOneWidget);
      expect(find.byType(TreinoExpansionTile), findsOneWidget);

      // Verify PlanoExpansionTile title is correct
      expect(find.textContaining('Plano Iniciante'), findsOneWidget);
      expect(find.textContaining('Ativo'), findsOneWidget);
      expect(find.textContaining('Treino A'), findsOneWidget);
    });

    testWidgets('expands PlanoExpansionTile correctly',
        (WidgetTester tester) async {
      // Build widget with mock data
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => themeProvider,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: PlanoExpansionTile(
                colorTheme: themeProvider.colorTheme,
                title: mockPlanoTreino.nome,
                status: mockPlanoTreino.status,
                editFunction: () {},
                deleteFunction: () {},
                deactivateFunction: () {},
                children: [
                  TreinoExpansionTile(
                    colorTheme: themeProvider.colorTheme,
                    title: mockTreino.nome,
                    children: const [],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify initial state
      expect(find.text('Plano Iniciante'), findsOneWidget);

      // Tap to expand
      await tester.tap(find.text('Plano Iniciante'));
      await tester.pumpAndSettle();

      // Verify treino is visible after expansion
      expect(find.text('Treino A'), findsOneWidget);
    });

    testWidgets('shows error message when plans fetch fails',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => themeProvider,
            ),
          ],
          child: const MaterialApp(
            home: AlunoPlanosTreino(
              alunoOnTest: null,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Nenhum plano encontrado'), findsOneWidget);
    });
  });
}
