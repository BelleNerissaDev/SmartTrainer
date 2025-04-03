import 'package:SmartTrainer_Personal/components/cards/history_anamneses_card.dart';
import 'package:SmartTrainer_Personal/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/anamnese.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:SmartTrainer_Personal/models/entity/sexo.dart';
import 'package:SmartTrainer_Personal/pages/widgets/anamnese_form_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/anamneses_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helpers.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirestore extends Mock implements FirebaseFirestore {}

void main() {
  group('AnamnesesPage Widget Tests', () {
    late FakeFirebaseFirestore instance;
    late List<Aluno> alunos;

    late AlunoRepository alunoRepository;

    setUp(() async {
      instance = FakeFirebaseFirestore();
      alunoRepository = AlunoRepository(firestore: instance);
      alunos = [
        Aluno(
          id: '',
          nome: 'Ana',
          telefone: '123456789',
          email: 'ana@example.com',
          sexo: Sexo.feminino.toString(),
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
        ),
        Aluno(
          id: '',
          nome: 'João',
          telefone: '123456789',
          email: 'john.doe@example.com',
          sexo: Sexo.masculino.toString(),
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
        ),
      ];

      for (var aluno in alunos) {
        final alunoDocument = await alunoRepository.create(aluno);
        aluno.id = alunoDocument.id!;
      }

      final respostasParq = RespostasParq(respostas: {
        'testeParqQ1': 'Não',
        'testeParqQ2': 'Não',
        'testeParqQ3': 'Não',
        'testeParqQ4': 'Não',
        'testeParqQ5': 'Não',
        'testeParqQ6': 'Não',
        'testeParqQ7': 'Não',
      });

      // Mock das respostas para RespostasHistSaude
      final respostasHistSaude = RespostasHistSaude(respostas: {
        'testeHistSaudeQ1': 'Fumo',
        'testeHistSaudeQ2': 'Não sei',
        'testeHistSaudeQ3': 'Não',
        'testeHistSaudeQ4': 'Não',
        'testeHistSaudeQ5': 'Não',
        'testeHistSaudeQ6': 'Não',
        'testeHistSaudeQ7': 'Não',
        'testeHistSaudeQ8': 'Menos que 1L',
        'testeHistSaudeQ9': 'Nenhum',
        'testeHistSaudeQ10': 'Nada',
      });

      final mockAnamnese = Anamnese(
        id: '',
        email: 'ana@example.com',
        idade: 23,
        data: DateTime(2023, 10, 1),
        nomeCompleto: 'John Doe',
        nomeResponsavel: 'John Doe',
        sexo: Sexo.masculino,
        status: StatusAnamneseEnum.PEDENTE,
        telefone: '123456789',
        nomeContatoEmergencia: 'John Doe',
        telefoneContatoEmergencia: '123456789',
        respostasParq: respostasParq,
        respostasHistSaude: respostasHistSaude,
      );

      alunos.first.addAnamnese(mockAnamnese);
    });

    testWidgets('renders AnamnesesPage correctly', (WidgetTester tester) async {
      // Inicializa a AnamnesesPage dentro do widget de teste
      await tester.pumpWidget(createWidgetUnderTest(
        child: AnamnesesPage(alunoOnTest: Future.value(alunos)),
      ));

      await tester.pumpAndSettle();

      // Verifica se o AppBar personalizado está sendo exibido
      expect(find.byType(CustomAppBar), findsOneWidget);

      // Verifica se o HeaderContainer está presente com o título correto
      expect(find.byType(HeaderContainer), findsOneWidget);
      // expect(find.text('Seus Anamneses'), findsOneWidget);

      // Verifica a presença do CardContainer
      expect(find.byType(CardContainer), findsWidgets);

      expect(find.byType(HistoryAnamensesCard), findsNWidgets(alunos.length));

      expect(find.widgetWithText(HistoryAnamensesCard, 'Ana'), findsOneWidget);
      expect(find.widgetWithText(HistoryAnamensesCard, 'João'), findsOneWidget);

      expect(find.textContaining('Pendente'), findsOneWidget);
      expect(find.textContaining('Não solicitado'), findsOneWidget);

      expect(find.widgetWithText(ElevatedButton, 'Solicitar'), findsOneWidget);

      await tester.longPress(find.widgetWithText(HistoryAnamensesCard, 'Ana'));
      await tester.pumpAndSettle();

      expect(find.byType(AnamneseFormPage), findsOneWidget);
    });

    // testWidgets('test the solicitarAction', (WidgetTester tester) async {
    //   // Inicializa a AnamnesesPage dentro do widget de teste
    //   await tester.pumpWidget(createWidgetUnderTest(
    //     child: AnamnesesPage(alunoOnTest: Future.value(alunos)),
    //   ));

    //   await tester.pumpAndSettle();

    // ignore: lines_longer_than_80_chars
    //   expect(find.widgetWithText(ElevatedButton, 'Solicitar'), findsOneWidget);

    // ignore: lines_longer_than_80_chars
    //   await tester.longPress(find.widgetWithText(ElevatedButton, 'Solicitar'));
    //   await tester.pumpAndSettle();

    //   // Espera por um determinado tempo antes de checar
    //   await tester.pump(const Duration(seconds: 10));

    //   // Verifica se o Snackbar aparece após a ação de solicitar
    //   expect(find.textContaining('Anamnese solicitada com sucesso'),
    //       findsOneWidget);
    // });
  });
}
