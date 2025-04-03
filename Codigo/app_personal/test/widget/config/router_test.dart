import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/fonts.dart';
import 'package:SmartTrainer_Personal/pages/widgets/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';

import '../../unit/config/router_test.dart';

@GenerateMocks([BuildContext])
void main() {
  group('Test navigation and rendering of all routes', () {});
  testWidgets('Test navigation and rendering of all routes',
      (WidgetTester tester) async {
    final mockContext = MockBuildContext();
    final key = GlobalKey();
    TextTheme textTheme =
        createTextTheme(mockContext, 'Montserrat', 'Montserrat');
    final colorFamily = CustomTheme.colorFamilyLight;
    CustomTheme theme = CustomTheme(textTheme);
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MaterialApp(
        key: key,
        title: 'App Personal',
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

      // Navega para a rota específica
      await tester.tap(find.text(route.pageName));
      await tester.pumpAndSettle();

      // Verifica se o tipo da página está correto após a navegação
      expect(find.byType(route.page.runtimeType), findsOneWidget);
    }
  });
}
