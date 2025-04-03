import 'package:SmartTrainer/components/botao.dart';
import 'package:SmartTrainer/components/input/text_input.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/pages/widgets/redefinir_senha_page.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('RedefinirSenhaPage displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MaterialApp(
          home: RedefinirSenhaPage(
            inTest: true,
          ),
        ),
      ),
    );

    expect(find.text('Para prosseguir, redefina sua senha'), findsOneWidget);
    expect(find.byType(ObscuredTextField), findsNWidgets(2));
    expect(find.byType(Botao), findsOneWidget);
  });

  testWidgets('RedefinirSenhaPage shows errors on invalid input',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MaterialApp(
          home: RedefinirSenhaPage(
            inTest: true,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(ObscuredTextField).first, 'short');
    await tester.enterText(find.byType(ObscuredTextField).last, 'short');
    await tester.tap(find.byType(Botao), warnIfMissed: false);
    await tester.pump();

    expect(find.text('- Pelo menos 8 caracteres'), findsOneWidget);
    expect(find.text('- Uma letra maiúscula'), findsOneWidget);
    expect(find.text('- Uma letra minúscula'), findsOneWidget);
    expect(find.text('- Um número'), findsOneWidget);
    expect(find.text('- Um caractere especial'), findsOneWidget);
    expect(find.text('As senhas não coincidem'), findsNothing);
  });

  testWidgets('RedefinirSenhaPage shows error when passwords do not match',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MaterialApp(
          home: RedefinirSenhaPage(
            inTest: true,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(ObscuredTextField).first, 'ValidPass1!');
    await tester.enterText(
        find.byType(ObscuredTextField).last, 'DifferentPass1!');
    await tester.tap(find.byType(Botao));
    await tester.pump();

    expect(find.text('As senhas não coincidem'), findsOneWidget);
  });
}
