import 'package:SmartTrainer_Personal/components/buttons/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActionButton Widget Tests', () {
    testWidgets('renders ActionButton with correct icon and colors',
        (WidgetTester tester) async {
      // Dados de teste para o botão
      final icon = Icons.add;
      final iconColor = Colors.white;
      final backgroundColor = Colors.blue;

      // Renderiza o ActionButton
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionButton(
              icon: icon,
              iconColor: iconColor,
              backgroundColor: backgroundColor,
              onTap: () {}, // Callback vazio para teste
            ),
          ),
        ),
      );

      // Verifica se o ícone está presente no widget
      final iconFinder = find.byIcon(icon);
      expect(iconFinder, findsOneWidget);

      // Verifica se o ícone possui a cor correta
      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.color, iconColor);

      // Verifica se o botão possui a cor de fundo correta
      final containerFinder = find.byType(Container);
      final containerWidget = tester.widget<Container>(containerFinder);
      final boxDecoration = containerWidget.decoration! as BoxDecoration;
      expect(boxDecoration.color, backgroundColor);
    });

    testWidgets('executes onTap callback when tapped',
        (WidgetTester tester) async {
      bool tapped = false;

      // Renderiza o ActionButton com um callback que muda o estado do bool
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionButton(
              icon: Icons.add,
              iconColor: Colors.white,
              backgroundColor: Colors.blue,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Simula o toque no botão
      await tester.tap(find.byType(ActionButton));
      await tester.pumpAndSettle();

      // Verifica se o callback foi acionado
      expect(tapped, isTrue);
    });
  });
}
