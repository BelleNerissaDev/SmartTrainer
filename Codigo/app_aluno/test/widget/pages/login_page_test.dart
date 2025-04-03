import 'package:SmartTrainer/components/botao.dart';
import 'package:SmartTrainer/components/input/text_input.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/pages/widgets/login_page.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('renders LoginPage correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MaterialApp(
          home: LoginPage(
            inTest: true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Bem-vindo'), findsOneWidget);
    expect(find.byType(Botao), findsOneWidget);
    expect(find.byType(ObscuredTextField), findsNWidgets(2));
  });

  testWidgets('shows error message when fields are empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MaterialApp(
          home: LoginPage(
            inTest: true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byType(Botao));
    await tester.pump();

    expect(find.text('Preencha todos os campos'), findsOneWidget);
  });

  testWidgets(
      'shows error message when email field is empty on resend password',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MaterialApp(
          home: LoginPage(
            inTest: true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextButton));
    await tester.pump();

    expect(find.text('Preencha o campo de email'), findsOneWidget);
  });
}
