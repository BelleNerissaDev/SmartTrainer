import 'package:SmartTrainer_Personal/components/buttons/action_button.dart';
import 'package:SmartTrainer_Personal/components/buttons/primary_button.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/sections/card_calendario_treinos.dart';
import 'package:SmartTrainer_Personal/components/sections/icons_feedback.dart';
import 'package:SmartTrainer_Personal/components/sections/info_aluno_avaliacoes.dart';
import 'package:SmartTrainer_Personal/components/sections/info_aluno_pacote.dart';
import 'package:SmartTrainer_Personal/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:SmartTrainer_Personal/models/entity/sexo.dart';
import 'package:SmartTrainer_Personal/pages/widgets/aluno_perfil_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/aluno_planos_treino.dart';
import 'package:SmartTrainer_Personal/pages/widgets/edicao_perfil_aluno_page.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';

void main() {
  late Aluno aluno;
  late AlunoRepository alunoRepository;
  late FakeFirebaseFirestore fakeFirestore;

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
          RoutesNames.alunoPlanosTreinos.route: (context) =>
              const AlunoPlanosTreino(),
          RoutesNames.edicaoAluno.route: (context) => const EdicaoPerfilAluno(),
        },
      ),
    );
  }

  setUp(() async {
    fakeFirestore = FakeFirebaseFirestore();
    alunoRepository = AlunoRepository(firestore: fakeFirestore);

    aluno = Aluno(
      nome: 'Ana',
      id: '1',
      telefone: '123456789',
      email: 'john.doe@example.com',
      sexo: Sexo.masculino.toString(),
      status: StatusAlunoEnum.ATIVO,
      peso: 70.5,
      altura: 180,
      uid: 'uid',
      imagem: null,
      primeiroAcesso: true,
      dataNascimento: DateTime.now(),
      pacote: Pacote(
        nome: 'pacote 1',
        valorMensal: '200.0',
        numeroAcessos: '50',
      ),
    );
    await alunoRepository.create(aluno);
  });

  group('AlunoPerfil Page Tests', () {
    testWidgets('renders AlunoPerfil components correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: AlunoPerfil(
          alunoOnTest: aluno,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CustomAppBar), findsOneWidget);

      expect(find.byType(ActionButton), findsNWidgets(2));

      expect(find.byType(InfoAlunoPacoteComEdicao), findsOneWidget);

      expect(find.byType(IconsFeedback), findsOneWidget);

      expect(find.byType(InfoAlunoAvaliacoes), findsOneWidget);

      final anamneseCenterTitle = find.byKey(const ValueKey('anamnesetitle'));
      expect(anamneseCenterTitle, findsOneWidget);

      await tester.pumpAndSettle();
      var finder = find.byType(InfoAlunoAvaliacoes);
      var moveBy = const Offset(0, -400);
      var dragDuration = const Duration(seconds: 1);

      await tester.timedDrag(finder, moveBy, dragDuration, warnIfMissed: false);

      expect(find.text('Sem treinos realizados'), findsOneWidget);

      await tester.pumpAndSettle();
      finder = find.text('Sem treinos realizados');
      moveBy = const Offset(0, -400);
      dragDuration = const Duration(seconds: 1);

      await tester.timedDrag(finder, moveBy, dragDuration, warnIfMissed: false);

      expect(find.byType(CardCalendarioTreinos), findsOneWidget);

      await tester.pumpAndSettle();
      finder = find.byType(CardCalendarioTreinos);
      moveBy = const Offset(0, -100);
      dragDuration = const Duration(seconds: 1);

      await tester.timedDrag(finder, moveBy, dragDuration, warnIfMissed: false);

      expect(
          find.widgetWithText(PrimaryButton, 'Excluir Aluno'), findsOneWidget);
    });

    testWidgets('displays correct student ans package information',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: AlunoPerfil(
          alunoOnTest: aluno,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Ana'), findsOneWidget);

      expect(find.text('john.doe@example.com'), findsOneWidget);

      expect(find.text('123456789'), findsOneWidget);

      expect(find.text('Ativo'), findsOneWidget);

      expect(find.text('Pacote atual'), findsOneWidget);
      expect(find.textContaining('200.0'), findsOneWidget);
      expect(find.textContaining('50'), findsOneWidget);

      expect(find.textContaining('Trocar Pacote'), findsOneWidget);
    });

    testWidgets('clicks on ActionButton edit student',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: AlunoPerfil(
          alunoOnTest: aluno,
        ),
      ));

      await tester.pumpAndSettle();

      final editCenterButton = find.byKey(const ValueKey('editaralunobtn'));
      expect(editCenterButton, findsOneWidget);

      await tester.longPress(editCenterButton);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      expect(find.byType(EdicaoPerfilAluno), findsOneWidget);
    });

    testWidgets('clicks on ActionButton view student train plans',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: AlunoPerfil(
          alunoOnTest: aluno,
        ),
      ));

      await tester.pumpAndSettle();

      final editCenterButton = find.byKey(const ValueKey('planosalunobtn'));
      expect(editCenterButton, findsOneWidget);

      await tester.longPress(editCenterButton);

      await tester.pumpAndSettle();

      expect(find.byType(AlunoPlanosTreino), findsOneWidget);
    });

    testWidgets('displays correct status for inactive student',
        (WidgetTester tester) async {
      aluno = Aluno(
        nome: 'Ana',
        telefone: '123456789',
        email: 'john.doe@example.com',
        sexo: 'Male',
        status: StatusAlunoEnum.BLOQUEADO,
        peso: 70.5,
        altura: 180,
        uid: 'uid',
        imagem: null,
        primeiroAcesso: true,
        dataNascimento: DateTime.now(),
        pacote: Pacote(
          nome: 'pacote 1',
          valorMensal: '200.0',
          numeroAcessos: '50',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest(
        child: AlunoPerfil(
          alunoOnTest: aluno,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Bloqueado'), findsOneWidget);
    });
  });
}
