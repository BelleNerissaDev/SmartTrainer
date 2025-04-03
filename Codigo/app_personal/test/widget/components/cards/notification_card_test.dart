import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer_Personal/components/cards/notification_card.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('CardCalendarioTreinos Widget Tests', () {
    testWidgets('NotificationCard displays correct information',
        (WidgetTester tester) async {
      const avatarUrl = 'assets/images/rafiki_avatar.png';
      const message = 'This is a test notification';
      const dateTime = '2024-09-01 10:00 AM';
      const nome = 'Rafiki';

      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(builder: (context) {
          var colorTheme = CustomTheme.colorFamilyLight;
          return NotificationCard(
            nome: nome,
            colorTheme: colorTheme,
            avatarUrl: null,
            message: message,
            dateTime: dateTime,
          );
        }),
      ));

      expect(find.byType(CircleAvatar), findsOneWidget);
      final avatarFinder = find.byType(CircleAvatar);
      expect(tester.widget<CircleAvatar>(avatarFinder).backgroundImage,
          isA<AssetImage>());
      expect(
          (tester.widget<CircleAvatar>(avatarFinder).backgroundImage!
                  as AssetImage)
              .assetName,
          equals(avatarUrl));

      expect(find.text('$nome $message'), findsOneWidget);

      expect(find.text(dateTime), findsOneWidget);
    });
  });
}
