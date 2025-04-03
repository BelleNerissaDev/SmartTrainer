import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/fonts.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/pacote.dart';

import 'package:SmartTrainer/pages/widgets/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/config/router.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';

import '../../unit/config/router_test.dart';

@GenerateMocks([BuildContext])
void main() {
  testWidgets('Test navigation and rendering of all routes',
      (WidgetTester tester) async {
    final mockContext = MockBuildContext();
    final key = GlobalKey();
    TextTheme textTheme =
        createTextTheme(mockContext, 'Montserrat', 'Montserrat');
    final colorFamily = CustomTheme.colorFamilyLight;
    final alunoProvider = AlunoProvider();
    alunoProvider.setAluno(Aluno(
      nome: 'nome',
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

    CustomTheme theme = CustomTheme(textTheme);
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => alunoProvider),
      ],
      child: MaterialApp(
        key: key,
        title: 'App Aluno',
        theme: theme.theme(colorFamily, Brightness.light),
        darkTheme: theme.theme(colorFamily, Brightness.dark),
        routes: Routes.route(mockContext),
        initialRoute: RoutesNames.home.route,
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);

    for (RoutesNames route in RoutesNames.menuRoutes) {
      ScaffoldState scaffoldState = tester.firstState(find.byType(Scaffold));
      scaffoldState.openDrawer();

      await tester.pumpAndSettle();
      expect(find.text(route.pageName), findsOneWidget);

      await tester.tap(find.text(route.pageName));
      await tester.pumpAndSettle();

      expect(find.byType(route.page.runtimeType), findsOneWidget);
    }
  });
}
