import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/cards/notification_card.dart';
import 'package:SmartTrainer_Personal/components/drawers/notification_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('Notification Menu Widget Tests', () {
    testWidgets('renders notification menu items with correct icons and titles',
        (WidgetTester tester) async {
      // Renderizando o Menu
      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(builder: (context) {
          var colorTheme = CustomTheme.colorFamilyLight;
          return NotificationMenu(colorTheme: colorTheme);
        }),
      ));

      // Verificando se todos os itens do menu estão presentes
      expect(find.text('Notificações'), findsOneWidget);
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('renders notification card items with correct icons and titles',
        (WidgetTester tester) async {
      final List<Map<String, String>> notifications = [
        {
          'message': 'Ana finalizou um treino',
          'avatarUrl': 'assets/images/rafiki_avatar.png',
          'dateTime': '28 Aug, 14:30', // URL do avatar
        },
        {
          'message': 'Ana iniciou um treino',
          'avatarUrl': 'assets/images/rafiki_avatar.png',
          'dateTime': '28 Aug, 14:30', // URL do avatar
        },
        {
          'message': 'Ana realizou seu primeiro acesso',
          'avatarUrl': 'assets/images/rafiki_avatar.png',
          'dateTime': '28 Aug, 14:30', // URL do avatar
        },
      ];
      // Renderizando o Menu
      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(builder: (context) {
          var colorTheme = CustomTheme.colorFamilyLight;
          return NotificationCard(
            colorTheme: colorTheme,
            nome: '',
            avatarUrl: null,
            message: notifications[0]['message']!,
            dateTime: notifications[0]['dateTime']!,
          );
        }),
      ));

      await tester.pumpAndSettle();

      // Verificando se todos os itens do menu estão presentes
      expect(find.textContaining('Ana finalizou um treino'), findsOneWidget);
      expect(find.textContaining('28 Aug, 14:30'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });
}
