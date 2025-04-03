import 'dart:io';

import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/cards/student_card.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
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
  group('StudentCard Widget Tests', () {
    setUpAll(() {
      HttpOverrides.global = _MyHttpOverrides();
    });

    late Aluno aluno;

    setUp(() {
      aluno = Aluno(
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
      );
    });
    testWidgets('renders StudentCard with no image correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(builder: (context) {
          var colorTheme = CustomTheme.colorFamilyLight;
          return StudentCard(
            colorTheme: colorTheme,
            aluno: aluno,
          );
        }),
      ));
      // Verificando se todos os itens do menu estão presentes
      expect(find.text('Ana'), findsOneWidget);
      expect(find.text('Ativo'), findsOneWidget);
    });
    testWidgets('renders StudentCard with image correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(builder: (context) {
          var colorTheme = CustomTheme.colorFamilyLight;
          return StudentCard(
            colorTheme: colorTheme,
            aluno: aluno,
          );
        }),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Ana'), findsOneWidget);
      expect(find.text('Ativo'), findsOneWidget);
    });
  });
}
