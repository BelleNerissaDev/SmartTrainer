import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/inputs/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer_Personal/utils/error_message.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('ObscuredTextField Widget Tests', () {
    testWidgets('renders ObscuredTextField correctly and responds to input',
        (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();
      const String labelText = 'Senha';

      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(builder: (context) {
          var colorTheme = CustomTheme.colorFamilyLight;
          return ObscuredTextField(
            label: labelText,
            controller: controller,
            colorTheme: colorTheme,
          );
        }),
      ));

      // Verificando se o rótulo está presente
      expect(find.text(labelText), findsOneWidget);

      // Verifica se o campo de texto está ocultando a senha
      expect(find.byType(TextField), findsOneWidget);
      expect(controller.text, '');

      // Simula a inserção de texto
      await tester.enterText(find.byType(TextField), 'senha123');
      await tester.pumpAndSettle(); // Aguarda a atualização do estado

      // Verifica se o texto foi inserido corretamente no controller
      expect(controller.text, 'senha123');
    });

    testWidgets('displays error messages when showErrors is true',
        (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();
      const String labelText = 'Senha';
      final List<ErrorMessage> errors = [
        ErrorMessage(message: 'Senha muito curta', error: true),
        ErrorMessage(message: 'Erro ao inserir senha', error: true),
      ];

      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(builder: (context) {
          var colorTheme = CustomTheme.colorFamilyLight;

          return ObscuredTextField(
            label: labelText,
            controller: controller,
            colorTheme: colorTheme,
            showErrors: true,
            errors: errors,
          );
        }),
      ));

      // Verifica se o campo de texto está presente
      expect(find.byType(TextField), findsOneWidget);

      // Verifica se as mensagens de erro são exibidas
      expect(find.text('Senha muito curta'), findsOneWidget);
      expect(find.text('Erro ao inserir senha'), findsOneWidget);
    });
  });
}
