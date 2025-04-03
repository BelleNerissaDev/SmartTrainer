import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ColorFamily _colorTheme = CustomTheme.colorFamilyLight;

  ColorFamily get colorTheme => _colorTheme;

  void updateTheme(Brightness brightness) {
    if (brightness == Brightness.light) {
      _colorTheme = CustomTheme.colorFamilyLight;
    } else {
      _colorTheme = CustomTheme.colorFamilyDark;
    }
    notifyListeners();
  }
}
