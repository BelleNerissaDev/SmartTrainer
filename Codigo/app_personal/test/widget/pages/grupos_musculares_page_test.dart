import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';
import 'package:SmartTrainer_Personal/pages/widgets/grupos_musculares_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  late List<GrupoMuscular> mockGrupoMusculares;

  setUp(() {
    mockGrupoMusculares = [
      GrupoMuscular(id: 'peitoral', nome: 'Peitoral'),
      GrupoMuscular(id: 'pernas', nome: 'Pernas'),
      GrupoMuscular(id: 'costas', nome: 'Costas')
    ];
  });

  Widget createWidgetUnderTest({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('GruposMuscularesPage Widget Tests', () {
    testWidgets('renders GruposMuscularesPage with icons and names',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: GruposMuscularesPage(
          gruposMuscularesOnTest: Future.value(mockGrupoMusculares),
        ),
      ));

      await tester.pumpAndSettle();

      // Verifica a presença dos nomes dos grupos musculares
      expect(find.textContaining('Peitoral'), findsOneWidget);
      expect(find.textContaining('Perna'), findsOneWidget);
      expect(find.textContaining('Costas'), findsOneWidget);
    });
  });
}
