import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/pages/widgets/alunos_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/anamneses_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/exercicios_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/grupos_musculares_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/home_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/pacotes_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  test('Routes should contain the correct routes and pages', () {
    final mockContext = MockBuildContext();
    final routes = Routes.route(mockContext);

    expect(routes.containsKey(RoutesNames.home.route), true);
    expect(routes[RoutesNames.home.route]!(mockContext), isA<HomePage>());

    expect(routes.containsKey(RoutesNames.pacotes.route), true);
    expect(routes[RoutesNames.pacotes.route]!(mockContext), isA<PacotesPage>());

    expect(routes.containsKey(RoutesNames.exercicios.route), true);
    expect(routes[RoutesNames.exercicios.route]!(mockContext),
        isA<ExerciciosPage>());

    expect(routes.containsKey(RoutesNames.alunos.route), true);
    expect(routes[RoutesNames.alunos.route]!(mockContext), isA<AlunosPage>());

    expect(routes.containsKey(RoutesNames.gruposMusculares.route), true);
    expect(routes[RoutesNames.gruposMusculares.route]!(mockContext),
        isA<GruposMuscularesPage>());

    expect(routes.containsKey(RoutesNames.anamnese.route), true);
    expect(
        routes[RoutesNames.anamnese.route]!(mockContext), isA<AnamnesesPage>());
  });
}
