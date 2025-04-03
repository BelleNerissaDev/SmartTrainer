import 'package:flutter/material.dart';
import 'package:SmartTrainer/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  MyColorFamily _colorTheme = CustomTheme.colorFamilyLight;

  MyColorFamily get colorTheme => _colorTheme;

  void updateTheme(Brightness brightness) {
    if (brightness == Brightness.light) {
      _colorTheme = CustomTheme.colorFamilyLight;
    } else {
      _colorTheme = CustomTheme.colorFamilyDark;
    }
    notifyListeners();
  }
}
