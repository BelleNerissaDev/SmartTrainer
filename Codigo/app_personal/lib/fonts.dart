import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension CustomTextStyles on TextTheme {
  TextStyle? get display96px => displayLarge?.copyWith(fontSize: 96);
  TextStyle? get display60px => displayMedium?.copyWith(fontSize: 60);
  TextStyle? get display48px => displaySmall?.copyWith(fontSize: 48);
  TextStyle? get headline34px => headlineLarge?.copyWith(fontSize: 34);
  TextStyle? get headline24px => headlineMedium?.copyWith(fontSize: 24);
  TextStyle? get headline20px => headlineSmall?.copyWith(fontSize: 20);
  TextStyle? get title18px => titleMedium?.copyWith(fontSize: 18);
  TextStyle? get title16px => titleMedium?.copyWith(fontSize: 16);
  TextStyle? get title14px => titleSmall?.copyWith(fontSize: 14);
  TextStyle? get body16px => bodyLarge?.copyWith(fontSize: 16);
  TextStyle? get body14px => bodyMedium?.copyWith(fontSize: 14);
  TextStyle? get body12px => bodySmall?.copyWith(fontSize: 12);
  TextStyle? get label14px => labelLarge?.copyWith(fontSize: 14);
  TextStyle? get label10px => labelSmall?.copyWith(fontSize: 10);
}

TextTheme createTextTheme(
    BuildContext context, String bodyFontString, String displayFontString) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;
  TextTheme displayTextTheme =
      GoogleFonts.getTextTheme(displayFontString, baseTextTheme);

  return displayTextTheme;
}
