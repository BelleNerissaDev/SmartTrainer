import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/config/router.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/menu.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../unit/entity/model/avaliacao_fisica_test.mocks.dart';

@GenerateMocks([Aluno])
void main() {
  group('Menu Widget', () {
    testWidgets('Widget builds correctly', (WidgetTester tester) async {
      final theme = CustomTheme.colorFamilyLight;
      final aluno = MockAluno();
      when(aluno.nome).thenReturn('Nome do Aluno');
      when(aluno.imagem).thenReturn(null);
      AlunoProvider alunoProvider = AlunoProvider();
      alunoProvider.setAluno(aluno);
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => alunoProvider,
          child: MaterialApp(
          home: Scaffold(
            drawer: Menu(colorTheme: theme),
          ),
        ),
        ),
      );

      ScaffoldState scaffoldState = tester.firstState(find.byType(Scaffold));
      scaffoldState.openDrawer();

      await tester.pumpAndSettle();

      expect(find.byType(Drawer), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(DrawerHeader), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('Nome do Aluno'), findsOneWidget);
      for (RoutesNames route in RoutesNames.menuRoutes) {
        expect(find.text(route.pageName), findsOneWidget);
      }
      expect(find.byType(IconButton), findsNWidgets(2));
      expect(
          find.byType(ListTile), findsNWidgets(RoutesNames.menuRoutes.length));
    });
  });
}
