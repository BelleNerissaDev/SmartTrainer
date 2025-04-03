import 'dart:io';

import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/pacote.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/header/card_nome_aluno.dart';
import 'package:provider/provider.dart';

class _MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context);
  }
}

void main() {
  late AlunoProvider alunoProvider;

  setUpAll(() {
    HttpOverrides.global = _MyHttpOverrides();
  });

  setUp(() {
    alunoProvider = AlunoProvider();
    alunoProvider.setAluno(Aluno(
      nome: 'Nome do Aluno',
      telefone: 'telefone',
      email: 'email',
      sexo: 'sexo',
      status: StatusAlunoEnum.ATIVO,
      peso: 75.9,
      altura: 180,
      uid: 'uid',
      primeiroAcesso: false,
      dataNascimento: DateTime(1990, 1, 1),
      pacote: Pacote(
        nome: 'pacote 1',
        valorMensal: '200',
        numeroAcessos: '20',
      ),
    ));
  });
  group('CardNomeAluno', () {
    testWidgets('renders text correctly', (WidgetTester tester) async {
      final theme = CustomTheme.colorFamilyLight;
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => alunoProvider,
          child: MaterialApp(
            home: CardNomeAluno(
              colorTheme: theme,
            ),
          ),
        ),
      );

      expect(find.text('Olá,'), findsOneWidget);
      expect(find.text('Nome do Aluno'), findsOneWidget);
    });

    testWidgets('renders circle avatar correctly', (WidgetTester tester) async {
      final theme = CustomTheme.colorFamilyLight;
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => alunoProvider,
          child: MaterialApp(
            home: CardNomeAluno(
              colorTheme: theme,
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
    });
    testWidgets('renders CircularProgressIndicator when aluno is null',
        (WidgetTester tester) async {
      final theme = CustomTheme.colorFamilyLight;
      alunoProvider.clearAluno();
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => alunoProvider,
          child: MaterialApp(
            home: CardNomeAluno(
              colorTheme: theme,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders default icon when aluno image is null',
        (WidgetTester tester) async {
      final theme = CustomTheme.colorFamilyLight;
      alunoProvider.setAluno(Aluno(
        nome: 'Nome do Aluno',
        telefone: 'telefone',
        email: 'email',
        sexo: 'sexo',
        status: StatusAlunoEnum.ATIVO,
        peso: 75.9,
        altura: 180,
        uid: 'uid',
        primeiroAcesso: false,
        imagem: null, // Set image to null
        dataNascimento: DateTime(1990, 1, 1),
        pacote: Pacote(
          nome: 'pacote 1',
          valorMensal: '200',
          numeroAcessos: '20',
        ),
      ));
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => alunoProvider,
          child: MaterialApp(
            home: CardNomeAluno(
              colorTheme: theme,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('renders network image when aluno image is provided',
        (WidgetTester tester) async {
      final theme = CustomTheme.colorFamilyLight;
      alunoProvider.setAluno(Aluno(
        nome: 'Nome do Aluno',
        telefone: 'telefone',
        email: 'email',
        sexo: 'sexo',
        status: StatusAlunoEnum.ATIVO,
        peso: 75.9,
        altura: 180,
        uid: 'uid',
        primeiroAcesso: false,
        imagem: 'https://picsum.photos/200', // Provide a valid image URL
        dataNascimento: DateTime(1990, 1, 1),
        pacote: Pacote(
          nome: 'pacote 1',
          valorMensal: '200',
          numeroAcessos: '20',
        ),
      ));
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => alunoProvider,
          child: MaterialApp(
            home: CardNomeAluno(
              colorTheme: theme,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });
  });
}
