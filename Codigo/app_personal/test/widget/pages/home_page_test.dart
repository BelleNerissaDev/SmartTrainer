import 'package:SmartTrainer_Personal/pages/widgets/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer_Personal/components/sections/statistics_dot.dart';
import 'package:SmartTrainer_Personal/components/drawers/menu.dart';
import 'package:SmartTrainer_Personal/components/titles/home_section_title.dart';
// import 'package:SmartTrainer_Personal/components/cards/feedback_home_carrousel.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('renders HomePage correctly', (WidgetTester tester) async {
      // Inicializa a página HomePage dentro do widget de teste
      await tester.pumpWidget(createWidgetUnderTest(
        child: const HomePage(),
      ));

      // Verifica se o AppBar personalizado está sendo exibido
      expect(find.byType(CustomAppBar), findsOneWidget);

      // Verifica se o HeaderContainer está presente com o título correto
      expect(find.byType(HeaderContainer), findsOneWidget);
      expect(find.text('Bem-vinda, Aline!'), findsOneWidget);

      // Verifica a presença do CardContainer
      expect(find.byType(CardContainer), findsOneWidget);

      // Verifica a presença dos widgets de estatísticas
      expect(find.byType(StatisticsDot), findsNWidgets(3));
      expect(find.text('Alunos cadastrados'), findsOneWidget);
      expect(find.text('0'), findsNWidgets(3));
      expect(find.text('Planos de treino'), findsOneWidget);
      expect(find.text('Avaliações físicas pendentes'), findsOneWidget);

      // Verifica a presença do título da seção de feedback
      expect(find.byType(HomeSectionTitle), findsOneWidget);

      // Verifica a presença do FeedbackCarousel
      // expect(find.byType(FeedbackCarousel), findsOneWidget);
    });

    testWidgets('opens drawer when menu icon is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: const HomePage(),
      ));

      // Abre o menu lateral ao clicar no ícone de menu do AppBar
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Verifica se o Menu foi aberto
      expect(find.byType(Menu), findsOneWidget);
    });

    testWidgets('opens endDrawer when notification icon is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: const HomePage(),
      ));

      // Abre o menu de notificações ao clicar no ícone de notificação do AppBar
      await tester.tap(find.byIcon(Icons.notifications));
      await tester.pumpAndSettle();

      // Verifica se o NotificationMenu foi aberto
      expect(find.byType(Drawer), findsOneWidget);
    });
  });
}
