import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:SmartTrainer_Personal/pages/widgets/aluno_perfil_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/alunos_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/inputs/search_bar.dart'
    as custom;
import 'package:SmartTrainer_Personal/components/cards/student_card.dart';
import 'package:SmartTrainer_Personal/pages/widgets/novo_aluno_page.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('AlunosPage Widget Tests', () {
    // Lista de exemplo de usuários remover após integração com o Firebase
    final users = [
      Aluno(
        nome: 'Ana',
        telefone: '123456789',
        email: 'john.doe@example.com',
        sexo: 'Male',
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
        nome: 'João',
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
      ),
      // Adicione mais usuários aqui
    ];

    testWidgets('renders AlunosPage correctly', (WidgetTester tester) async {
      // Inicializa a AlunosPage dentro do widget de teste
      await tester.pumpWidget(createWidgetUnderTest(
        child: AlunosPage(alunosOnTest: users),
      ));

      await tester.pumpAndSettle();

      // Verifica se o AppBar personalizado está sendo exibido
      expect(find.byType(CustomAppBar), findsOneWidget);

      // Verifica se o HeaderContainer está presente com o título correto
      expect(find.byType(HeaderContainer), findsOneWidget);
      expect(find.text('Seus Alunos'), findsOneWidget);

      // Verifica a presença do CardContainer
      expect(find.byType(CardContainer), findsOneWidget);

      // Verifica se a SearchPage (barra de busca) está presente
      expect(find.byType(custom.SearchBar), findsOneWidget);

      // Verifica se os StudentCards estão sendo exibidos
      expect(find.byType(StudentCard), findsNWidgets(users.length));

      // Verifica se os dados dos alunos estão corretos
      for (var user in users) {
        expect(find.text(user.nome), findsOneWidget);
        expect(find.text(user.status.toString()).first, findsOneWidget);
      }
      await tester.pumpAndSettle();

      expect(find.byType(StudentCard).first, findsOneWidget);
      // Simula o clique no card de detalhes do aluno
      await tester.tap(find.byType(StudentCard).last);

      await tester.pumpAndSettle();

      // Verifica se a página de novo aluno (NovoAlunoPage) foi carregada
      expect(find.byType(AlunoPerfil), findsOneWidget);
    });

    testWidgets('allows interaction with floating action button',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: AlunosPage(alunosOnTest: users),
      ));

      await tester.pumpAndSettle();

      // Verifica se o FloatingActionButton está presente
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Simula o clique no botão de adicionar novo aluno
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verifica se a página de novo aluno (NovoAlunoPage) foi carregada
      expect(find.byType(NovoAlunoPage), findsOneWidget);
    });
  });
}
