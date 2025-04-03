import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/radio_button/radio_button_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('CustomRadioButtonGroup Widget Tests', () {
    testWidgets('renders CustomRadioButtonGroup correctly',
        (WidgetTester tester) async {
      String? selectedOption;
      final bool showError = false;

      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(builder: (context) {
          var colorTheme = CustomTheme.colorFamilyLight;
          return CustomRadioButtonGroup(
            showError: showError,
            options: ['Sim', 'Não'],
            colorTheme: colorTheme,
            hadTextField: true,
            groupValue: selectedOption,
            onChanged: (value) {
              selectedOption = value;
            },
          );
        }),
      ));

      expect(
          find.widgetWithText(CustomRadioButtonGroup, 'Sim'), findsOneWidget);
      expect(
          find.widgetWithText(CustomRadioButtonGroup, 'Não'), findsOneWidget);

      final radioFinderSim = find
          .byWidgetPredicate(
            (widget) => widget is Radio<String>,
          )
          .first;

      await tester.tap(radioFinderSim);
      await tester.pumpAndSettle();

      expect(selectedOption, 'Sim');

      final radioFinderNao = find
          .byWidgetPredicate(
            (widget) => widget is Radio<String>,
          )
          .at(1);

      await tester.tap(radioFinderNao);
      await tester.pumpAndSettle();

      expect(selectedOption, 'Não');

      // TODO: Verificar se o TextField foi removido
      // expect(find.widgetWithText(TextField, 'Qual?'), findsNothing);
    });
  });
}
