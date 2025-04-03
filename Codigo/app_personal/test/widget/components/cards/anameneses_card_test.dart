import 'dart:io';

import 'package:SmartTrainer_Personal/components/cards/history_anamneses_card.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/anamnese.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:SmartTrainer_Personal/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helpers.dart';

class _MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context);
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _MyHttpOverrides();
  });
  group('AnameneseCard Widget Tests', () {
    testWidgets('renders AnameneseCard with correct name, status, and date',
        (WidgetTester tester) async {
      final aluno = Aluno(
        pacote:
            Pacote(nome: 'teste', valorMensal: '200.00', numeroAcessos: '20'),
        dataNascimento: DateTime(1990, 5, 30),
        nome: 'John Doe',
        telefone: '123456789',
        email: 'john.doe@example.com',
        sexo: 'Male',
        status: StatusAlunoEnum.ATIVO,
        peso: 70.5,
        altura: 180,
        uid: 'uid',
        imagem: null,
        primeiroAcesso: false,
      );

      await tester.pumpWidget(createWidgetUnderTest(
        child: Column(
          children: [
            HistoryAnamensesCard(
              aluno: aluno,
              name: aluno.nome,
              status: StatusAnamneseEnum.REALIZADA.toString(),
              date: DateTime.now().toString(),
              profileImage: aluno.imagem,
            ),
          ],
        ),
      ));

      expect(find.text(aluno.nome), findsOneWidget);
      expect(find.textContaining('Realizada em'), findsOneWidget);
      expect(find.text(formatDate(DateTime.now().toString())), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('renders "Solicitar" button when status is "Não solicitado"',
        (WidgetTester tester) async {
      final aluno = Aluno(
        pacote:
            Pacote(nome: 'teste', valorMensal: '200.00', numeroAcessos: '20'),
        dataNascimento: DateTime(1990, 5, 30),
        nome: 'John Doe',
        telefone: '123456789',
        email: 'john.doe@example.com',
        sexo: 'Male',
        status: StatusAlunoEnum.ATIVO,
        peso: 70.5,
        altura: 180,
        uid: 'uid',
        imagem: null,
        primeiroAcesso: false,
      );

      await tester.pumpWidget(createWidgetUnderTest(
          child: Column(
        children: [
          HistoryAnamensesCard(
            aluno: aluno,
            name: aluno.nome,
            status: 'Não solicitado',
            date: DateTime.now().toString(),
            profileImage: aluno.imagem,
          ),
        ],
      )));

      expect(find.textContaining('Solicitar'), findsOneWidget);
    });

    testWidgets('does not bold text for "Realizada em:" status',
        (WidgetTester tester) async {
      final aluno = Aluno(
        pacote:
            Pacote(nome: 'teste', valorMensal: '200.00', numeroAcessos: '20'),
        dataNascimento: DateTime(1990, 5, 30),
        nome: 'John Doe',
        telefone: '123456789',
        email: 'john.doe@example.com',
        sexo: 'Male',
        status: StatusAlunoEnum.ATIVO,
        peso: 70.5,
        altura: 180,
        uid: 'uid',
        imagem: null,
        primeiroAcesso: false,
      );

      await tester.pumpWidget(createWidgetUnderTest(
          child: Column(
        children: [
          HistoryAnamensesCard(
            aluno: aluno,
            name: aluno.nome,
            status: StatusAnamneseEnum.PEDENTE.toString(),
            date: DateTime.now().toString(),
            profileImage: aluno.imagem,
          ),
        ],
      )));

      expect(find.textContaining(StatusAnamneseEnum.PEDENTE.toString()),
          findsOneWidget);
    });
  });
}
