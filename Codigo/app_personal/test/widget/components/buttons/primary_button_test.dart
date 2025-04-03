import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer_Personal/components/buttons/primary_button.dart';

import '../../../helpers/test_helpers.dart'; // Importa o helper

void main() {
  group('PrimaryButton Widget Tests', () {
    testWidgets('renders PrimaryButton correctly', (WidgetTester tester) async {
      var colorTheme = CustomTheme.colorFamilyLight;
      await tester.pumpWidget(createWidgetUnderTest(
        child: PrimaryButton(
          label: 'Salvar',
          onPressed: () => {},
          backgroundColor: colorTheme.indigo_primary_500,
        ),
      ));

      // Verifica se o botão foi renderizado corretamente
      expect(find.widgetWithText(ElevatedButton, 'Salvar'), findsOneWidget);
    });
  });
}
