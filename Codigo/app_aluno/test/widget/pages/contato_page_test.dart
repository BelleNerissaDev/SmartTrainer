import 'package:SmartTrainer/components/header/header.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/pages/widgets/contato_page.dart';

void main() {
  testWidgets('ContatoPage displays correct information',
      (WidgetTester tester) async {
    final themeProvider = ThemeProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => themeProvider),
          ChangeNotifierProvider(create: (_) => AlunoProvider()),
        ],
        child: const MaterialApp(
          home: ContatoPage(),
        ),
      ),
    );

    expect(find.byType(Header), findsOneWidget);
    expect(find.text('Aline Duarte'), findsOneWidget);
    expect(find.text('Personal Trainer'), findsOneWidget);
    expect(find.text('(31) 99737-8272'), findsOneWidget);
    expect(find.text('aline.dpsjo@yahoo.com.br'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/images/foto_personal.png',
      ),
      findsOneWidget,
    );
  });
}
