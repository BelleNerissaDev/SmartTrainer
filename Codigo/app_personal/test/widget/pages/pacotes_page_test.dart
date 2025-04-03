import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:SmartTrainer_Personal/pages/widgets/pacotes_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:SmartTrainer_Personal/pages/widgets/novo_pacote_page.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/cards/package_card.dart';

import '../../helpers/test_helpers.dart';


void main() {
  group('PacotesPage Widget Tests', () {
    testWidgets('renders PacotesPage correctly', (WidgetTester tester) async {
      final pacotes = [
        Pacote(nome: 'Pacote A', valorMensal: '100,00', numeroAcessos: '30'),
        Pacote(nome: 'Pacote B', valorMensal: '200,00', numeroAcessos: '60'),
        Pacote(nome: 'Pacote C', valorMensal: '300,00', numeroAcessos: '90'),
      ];

      await tester.pumpWidget(createWidgetUnderTest(
        child: PacotesPage(pacotesOnTest: () async {
          return pacotes;
        }()),
      ));

      await tester.pumpAndSettle();

      // Verifica se o AppBar personalizado está sendo exibido
      expect(find.byType(CustomAppBar), findsOneWidget);

      // Verifica se o HeaderContainer está presente com o título correto
      expect(find.byType(HeaderContainer), findsOneWidget);
      expect(find.text('Pacotes de treino'), findsOneWidget);

      // Verifica a presença do CardContainer
      expect(find.byType(CardContainer), findsOneWidget);

      // Verifica a presença dos PackageCards
      expect(find.byType(PackageCard), findsNWidgets(3));
      expect(find.text('Pacote A'), findsOneWidget);
      expect(find.text('Pacote B'), findsOneWidget);
      expect(find.text('Pacote C'), findsOneWidget);

      // Verifica se o FloatingActionButton está presente
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(SvgPicture), findsWidgets);
    });

    testWidgets('navigates to NovoPacotePage when FAB is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: const PacotesPage(),
      ));

      // Verifica se o FloatingActionButton está presente
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Simula o clique no FloatingActionButton
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verifica se a navegação para a página NovoPacotePage ocorreu
      expect(find.byType(NovoPacotePage), findsOneWidget);
    });
  });
}
