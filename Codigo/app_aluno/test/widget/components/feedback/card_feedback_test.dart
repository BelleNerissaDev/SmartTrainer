import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/input/text_input.dart';
import 'package:SmartTrainer/components/radio_button/icon_radio_button_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/feedback/card_feedback.dart';
import 'package:SmartTrainer/models/entity/nivel_esforco.dart';

void main() {
  group('CardFeedback', () {
    testWidgets('CardFeedback displays correct elements',
        (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();
      final NivelEsforco nivelEsforco = NivelEsforco.MEDIO;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardFeedback(
              colorTheme: CustomTheme.colorFamilyLight,
              nivelEsforco: nivelEsforco,
              onNivelEsforcoChanged: (int value) {},
              controller: controller,
              editavel: true,
            ),
          ),
        ),
      );

      expect(find.text('Treino completo!'), findsOneWidget);
      expect(
          find.text('Avalie seu nível de esforço do treino'), findsOneWidget);
      expect(find.text('Observações'), findsOneWidget);
      expect(find.byType(IconRadioGroup), findsOneWidget);
      expect(find.byType(MultilineTextField), findsOneWidget);
    });

    testWidgets('CardFeedback calls onNivelEsforcoChanged when icon is tapped',
        (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();
      final NivelEsforco nivelEsforco = NivelEsforco.MEDIO;
      int selectedValue = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardFeedback(
              colorTheme: CustomTheme.colorFamilyLight,
              nivelEsforco: nivelEsforco,
              onNivelEsforcoChanged: (int value) {
                selectedValue = value;
              },
              controller: controller,
              editavel: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Mdi.emoticonCoolOutline));
      await tester.pump();

      expect(selectedValue, 0);
    });

    testWidgets('CardFeedback updates text field', (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();
      final NivelEsforco nivelEsforco = NivelEsforco.MEDIO;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardFeedback(
              colorTheme: CustomTheme.colorFamilyLight,
              nivelEsforco: nivelEsforco,
              onNivelEsforcoChanged: (int value) {},
              controller: controller,
              editavel: true,
            ),
          ),
        ),
      );

      await tester.enterText(
          find.byType(MultilineTextField), 'Test observation');
      expect(controller.text, 'Test observation');
    });
  });
}
