import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/input/text_input.dart';
import 'package:provider/provider.dart';

void main() {
  group('ObscuredTextField', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      final controller = TextEditingController();
      final themeProvider = ThemeProvider();
      var colorTheme = CustomTheme.colorFamilyLight;
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => themeProvider,
          child: MaterialApp(
            home: Scaffold(
              body: Container(
                width: double.infinity,
                child: Center(
                  child: ObscuredTextField(
                    colorTheme: colorTheme,
                    label: 'Password',
                    controller: controller,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      final labelTextFinder = find.text('Password');
      expect(labelTextFinder, findsOneWidget);
    });
  });
}
