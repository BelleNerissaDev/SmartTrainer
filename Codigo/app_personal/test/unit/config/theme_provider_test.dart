import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';

void main() {
  group('ThemeProvider', () {
    test(
        '''updateTheme should update the color theme to light when brightness is light''',
        () {
      final themeProvider = ThemeProvider();
      themeProvider.updateTheme(Brightness.light);
      expect(themeProvider.colorTheme, equals(CustomTheme.colorFamilyLight));
    });

    test(
        '''updateTheme should update the color theme to dark when brightness is dark''',
        () {
      final themeProvider = ThemeProvider();
      themeProvider.updateTheme(Brightness.dark);
      expect(themeProvider.colorTheme, equals(CustomTheme.colorFamilyDark));
    });
  });
}
