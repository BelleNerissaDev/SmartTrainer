
import 'package:SmartTrainer/models/entity/pacote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/avaliacao_fisica.dart';
import 'package:SmartTrainer/pages/widgets/questionario_avaliacao_page.dart';

void main() {
  group('Questionario avaliação fisica page test', () {
    late Aluno aluno;
    late AvaliacaoFisica avaliacaoFisica;
    late AlunoProvider alunoProvider;

    setUp(() {
      alunoProvider = AlunoProvider();
      aluno = Aluno(
        nome: 'John Doe',
        telefone: '123456789',
        email: 'john.doe@example.com',
        sexo: 'Masculino',
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
      avaliacaoFisica = AvaliacaoFisica(
        data: DateTime(2021, 1, 1),
        tipoAvaliacao: TipoAvaliacao.online,
        status: StatusAvaliacao.realizada,
        aluno: aluno,
      );
      alunoProvider.setAluno(aluno);
    });
    testWidgets('QuestionarioAvaliacaoPage displays correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => alunoProvider),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: MaterialApp(
            initialRoute: '/',
            onGenerateRoute: (settings) {
              if (settings.name == '/') {
                return MaterialPageRoute(
                  builder: (context) => const QuestionarioAvaliacaoPage(),
                  settings: RouteSettings(arguments: avaliacaoFisica),
                );
              }
              return null;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Avaliação Física'), findsOneWidget);
      expect(find.text('Altura'), findsNWidgets(2));
      expect(find.text('Peso'), findsNWidgets(2));
      expect(find.text('Pescoço:'), findsNWidgets(2));
      expect(find.text('Cintura:'), findsNWidgets(2));
      expect(find.text('Quadril:'), findsNWidgets(2));

      expect(find.widgetWithText(ElevatedButton, 'Finalizar'), findsOneWidget);
    });

    testWidgets('QuestionarioAvaliacaoPage displays correct SVG for male',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => alunoProvider),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: MaterialApp(
            initialRoute: '/',
            onGenerateRoute: (settings) {
              if (settings.name == '/') {
                return MaterialPageRoute(
                  builder: (context) => const QuestionarioAvaliacaoPage(),
                  settings: RouteSettings(arguments: avaliacaoFisica),
                );
              }
              return null;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SvgPicture &&
              (widget.bytesLoader as SvgAssetLoader)
                      .assetName
                      .compareTo('assets/svg/silhueta_homem.svg') ==
                  0,
        ),
        findsOneWidget,
      );
    });

    testWidgets('QuestionarioAvaliacaoPage displays correct SVG for female',
        (WidgetTester tester) async {
      aluno.sexo = 'Feminino';
      alunoProvider.setAluno(aluno);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => alunoProvider),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: MaterialApp(
            initialRoute: '/',
            onGenerateRoute: (settings) {
              if (settings.name == '/') {
                return MaterialPageRoute(
                  builder: (context) => const QuestionarioAvaliacaoPage(),
                  settings: RouteSettings(arguments: avaliacaoFisica),
                );
              }
              return null;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SvgPicture &&
              (widget.bytesLoader as SvgAssetLoader)
                      .assetName
                      .compareTo('assets/svg/silhueta_mulher.svg') ==
                  0,
        ),
        findsOneWidget,
      );
    });

    testWidgets('QuestionarioAvaliacaoPage shows errors on invalid input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => alunoProvider),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: MaterialApp(
            initialRoute: '/',
            onGenerateRoute: (settings) {
              if (settings.name == '/') {
                return MaterialPageRoute(
                  builder: (context) => const QuestionarioAvaliacaoPage(),
                  settings: RouteSettings(arguments: avaliacaoFisica),
                );
              }
              return null;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), '');
      await tester.enterText(find.byType(TextField).at(1), '');
      await tester.enterText(find.byType(TextField).at(2), '');
      await tester.enterText(find.byType(TextField).at(3), '');
      await tester.enterText(find.byType(TextField).at(4), '');

      final botaoFinder = find.widgetWithText(ElevatedButton, 'Finalizar');
      expect(botaoFinder, findsOneWidget);

      final listFinder = find
          .byType(Scrollable)
          .last; // take last because the tab bar up top is also a Scrollable
      expect(listFinder, findsOneWidget);

      await tester.scrollUntilVisible(
        botaoFinder,
        500.0,
        scrollable: listFinder,
      );

      await tester.tap(botaoFinder);
      await tester.pumpAndSettle();

      expect(find.text('Insira a altura em cm'), findsOneWidget);
      expect(find.text('Insira o peso'), findsOneWidget);
      expect(find.text('Insira o pescoço'), findsOneWidget);
      expect(find.text('Insira a cintura'), findsOneWidget);
      expect(find.text('Insira o quadril'), findsOneWidget);
    });
  });
}
