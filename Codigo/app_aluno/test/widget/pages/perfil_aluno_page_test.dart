import 'dart:io';

import 'package:SmartTrainer/components/card_email_telefone.dart';
import 'package:SmartTrainer/components/card_infos_pessoais.dart';
import 'package:SmartTrainer/components/card_medidas.dart';
import 'package:SmartTrainer/components/card_pacote.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/pacote.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/pages/widgets/perfil_aluno_page.dart';

class _MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context);
  }
}

void main() {
  group('Perfil Auno Page', () {
    late Aluno aluno;

    setUp(() {
      aluno = Aluno(
        nome: 'John Doe',
        telefone: '123456789',
        email: 'john.doe@example.com',
        sexo: 'Male',
        status: StatusAlunoEnum.ATIVO,
        peso: 70.5,
        altura: 180,
        uid: 'uid',
        imagem: null,
        primeiroAcesso: true,
        dataNascimento: DateTime(1990, 1, 1),
        pacote: Pacote(
          nome: 'pacote 1',
          valorMensal: '200',
          numeroAcessos: '20',
        ),
      );
    });

    setUpAll(() {
      HttpOverrides.global = _MyHttpOverrides();
    });
    testWidgets('PerfilAlunoPage displays aluno information correctly',
        (WidgetTester tester) async {
      final alunoProvider = AlunoProvider();
      alunoProvider.setAluno(aluno);

      final themeProvider = ThemeProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AlunoProvider>(
              create: (_) => alunoProvider,
            ),
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => themeProvider,
            ),
          ],
          child: const MaterialApp(
            home: PerfilAlunoPage(),
          ),
        ),
      );

      expect(find.byType(PerfilAlunoPage), findsOneWidget);
      expect(find.byType(CardInfosPessoais), findsOneWidget);
      expect(find.byType(CardEmailTelefone), findsOneWidget);
      expect(find.byType(CardMedidas), findsOneWidget);
      expect(find.byType(CardPacote), findsOneWidget);

      expect(find.text('John Doe'), findsNWidgets(2));
      expect(find.text('john.doe@example.com'), findsOneWidget);
      expect(find.text('123456789'), findsOneWidget);
      expect(find.text(StatusAlunoEnum.ATIVO.toString()), findsOneWidget);
    });

    testWidgets('PerfilAlunoPage displays aluno correctly when has image',
        (WidgetTester tester) async {
      aluno.imagem = 'https://picsum.photos/200';

      final alunoProvider = AlunoProvider();
      alunoProvider.setAluno(aluno);

      final themeProvider = ThemeProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AlunoProvider>(
              create: (_) => alunoProvider,
            ),
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => themeProvider,
            ),
          ],
          child: const MaterialApp(
            home: PerfilAlunoPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(PerfilAlunoPage), findsOneWidget);
      expect(find.byType(CardInfosPessoais), findsOneWidget);
      expect(find.byType(CardEmailTelefone), findsOneWidget);
      expect(find.byType(CardMedidas), findsOneWidget);
      expect(find.byType(CardPacote), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(2));

      expect(find.text('John Doe'), findsNWidgets(2));
      expect(find.text('john.doe@example.com'), findsOneWidget);
      expect(find.text('123456789'), findsOneWidget);
      expect(find.text(StatusAlunoEnum.ATIVO.toString()), findsOneWidget);
    });

    testWidgets('PerfilAlunoPage displays aluno correctly when has no image',
        (WidgetTester tester) async {
      final alunoProvider = AlunoProvider();
      alunoProvider.setAluno(aluno);

      final themeProvider = ThemeProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AlunoProvider>(
              create: (_) => alunoProvider,
            ),
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => themeProvider,
            ),
          ],
          child: const MaterialApp(
            home: PerfilAlunoPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(PerfilAlunoPage), findsOneWidget);
      expect(find.byType(CardInfosPessoais), findsOneWidget);
      expect(find.byType(CardEmailTelefone), findsOneWidget);
      expect(find.byType(CardMedidas), findsOneWidget);
      expect(find.byType(CardPacote), findsOneWidget);
      expect(find.byIcon(Icons.person), findsNWidgets(2));

      expect(find.text('John Doe'), findsNWidgets(2));
      expect(find.text('john.doe@example.com'), findsOneWidget);
      expect(find.text('123456789'), findsOneWidget);
      expect(find.text(StatusAlunoEnum.ATIVO.toString()), findsOneWidget);
    });

    testWidgets(
        'PerfilAlunoPage displays correct status color for ATIVO status',
        (WidgetTester tester) async {
      final alunoProvider = AlunoProvider();
      alunoProvider.setAluno(aluno);

      final themeProvider = ThemeProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AlunoProvider>(
              create: (_) => alunoProvider,
            ),
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => themeProvider,
            ),
          ],
          child: const MaterialApp(
            home: PerfilAlunoPage(),
          ),
        ),
      );

      final statusText = find.text(StatusAlunoEnum.ATIVO.toString());
      expect(statusText, findsOneWidget);

      final statusTextWidget = tester.widget<Text>(statusText);
      expect(statusTextWidget.style?.color,
          themeProvider.colorTheme.green_sucess_500);
    });

    testWidgets(
        'PerfilAlunoPage displays correct status color for BLOQUEADO status',
        (WidgetTester tester) async {
      aluno.status = StatusAlunoEnum.BLOQUEADO;

      final alunoProvider = AlunoProvider();
      alunoProvider.setAluno(aluno);

      final themeProvider = ThemeProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AlunoProvider>(
              create: (_) => alunoProvider,
            ),
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => themeProvider,
            ),
          ],
          child: const MaterialApp(
            home: PerfilAlunoPage(),
          ),
        ),
      );

      final statusText = find.text(StatusAlunoEnum.BLOQUEADO.toString());
      expect(statusText, findsOneWidget);

      final statusTextWidget = tester.widget<Text>(statusText);
      expect(statusTextWidget.style?.color,
          themeProvider.colorTheme.red_error_500);
    });

    testWidgets('PerfilAlunoPage opens image picker dialog on button press',
        (WidgetTester tester) async {
      final alunoProvider = AlunoProvider();
      alunoProvider.setAluno(aluno);

      final themeProvider = ThemeProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AlunoProvider>(
              create: (_) => alunoProvider,
            ),
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => themeProvider,
            ),
          ],
          child: const MaterialApp(
            home: PerfilAlunoPage(),
          ),
        ),
      );

      await tester.tap(find.byIcon(Mdi.pencil));
      await tester.pumpAndSettle();

      expect(find.text('Remover foto'), findsOneWidget);
      expect(find.text('Câmera'), findsOneWidget);
      expect(find.text('Galeria'), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      expect(find.byIcon(Icons.photo_library), findsOneWidget);
    });
  });
}
