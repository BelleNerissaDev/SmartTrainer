import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/config/router.dart';
import 'package:SmartTrainer/pages/widgets/anamnese_page.dart';
import 'package:SmartTrainer/pages/widgets/avaliacoes_page.dart';
import 'package:SmartTrainer/pages/widgets/contato_page.dart';
import 'package:SmartTrainer/pages/widgets/home_page.dart';
import 'package:SmartTrainer/pages/widgets/treinos_page.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  test('Routes should contain the correct routes and pages', () {
    final mockContext = MockBuildContext();
    final routes = Routes.route(mockContext);

    expect(routes.containsKey(RoutesNames.home.route), true);
    expect(routes[RoutesNames.home.route]!(mockContext), isA<HomePage>());

    expect(routes.containsKey(RoutesNames.treinos.route), true);
    expect(routes[RoutesNames.treinos.route]!(mockContext), isA<TreinosPage>());

    expect(routes.containsKey(RoutesNames.avaliacoes.route), true);
    expect(routes[RoutesNames.avaliacoes.route]!(mockContext),
        isA<AvaliacoesPage>());

    expect(routes.containsKey(RoutesNames.anamnese.route), true);
    expect(
        routes[RoutesNames.anamnese.route]!(mockContext), isA<AnamnesePage>());

    expect(routes.containsKey(RoutesNames.contato.route), true);
    expect(routes[RoutesNames.contato.route]!(mockContext), isA<ContatoPage>());
  });
}
