import 'package:flutter/material.dart';

class CustomTheme {
  final TextTheme textTheme;

  const CustomTheme(this.textTheme);

  // {color_name}_{primary/secondary}_{opacity}

  static ColorFamily colorFamilyLight = const ColorFamily(
    // PRIMARY COLOR FAMILY
    indigo_primary_800: Color(0xFF4540f0),
    indigo_primary_700: Color(0xFF4F4CFA),
    indigo_primary_500: Color(0xFF6547DE),
    indigo_primary_400: Color(0xFF6D6AF8),
    indigo_primary_200: Color(0xFFc1c1ff),
    indigo_primary_100: Color(0xFFE0E0FD),
    white_onPrimary_100: Color(0xFFFFFFFF),

    // SECONDARY COLOR FAMILY
    lemon_secondary_800: Color(0xFFa2ac00),
    lemon_secondary_700: Color(0xFFc2da00),
    lemon_secondary_500: Color(0xFFcdec00),
    lemon_secondary_400: Color(0xFFE9FC83),
    lemon_secondary_200: Color(0xFFe8f795),
    lemon_secondary_100: Color(0xFFf1fac0),
    black_onSecondary_100: Color(0xFF080808),

    lilac_tertiary_200: Color(0xFFE1DFFF),
    black_tertiary_800: Color(0xFF181826),

    red_error_500: Color(4290386458),
    green_sucess_500: Color(0xFF00d929),

    light_container_500: Color(0xFFF6F7F2),
    grey_font_700: Color(0xFF5D5D74),
    grey_font_500: Color(0xFFBFBEB9),
  );

  ThemeData light() {
    return theme(colorFamilyLight, Brightness.light);
  }

  static ColorFamily colorFamilyDark = const ColorFamily(
    // PRIMARY COLOR FAMILY
    indigo_primary_800: Color(0xFF4540f0),
    indigo_primary_700: Color.fromRGBO(101, 71, 222, 1),
    indigo_primary_500: Color(0xFF4F4CFA),
    indigo_primary_400: Color(0xFF6D6AF8),
    indigo_primary_200: Color(0xFFc1c1ff),
    indigo_primary_100: Color(0xFFE0E0FD),
    white_onPrimary_100: Color(0xFFFFFFFF),

    // SECONDARY COLOR FAMILY
    lemon_secondary_800: Color(0xFFa2ac00),
    lemon_secondary_700: Color(0xFFc2da00),
    lemon_secondary_500: Color(0xFFcdec00),
    lemon_secondary_400: Color(0xFFD5F03E),
    lemon_secondary_200: Color(0xFFe8f795),
    lemon_secondary_100: Color(0xFFf1fac0),
    black_onSecondary_100: Color(0xFF080808),

    lilac_tertiary_200: Color(0xFFE1DFFF),
    black_tertiary_800: Color(0xFF181826),

    red_error_500: Color(4290386458),
    green_sucess_500: Color(0xFF00d929),

    light_container_500: Color(0xFFF6F7F2), // Fundo de container escuro
    grey_font_700: Color(0xFF5D5D74),
    grey_font_500: Color(0xFFBFBEB9),
  );

  ThemeData dark() {
    // Você pode definir diferentes cores para o tema escuro, se necessário
    return theme(colorFamilyDark, Brightness.dark);
  }

  ThemeData theme(ColorFamily colors, Brightness brightness) => ThemeData(
        brightness: brightness, // Ou Brightness.dark para o tema escuro
        primaryColor: colors.indigo_primary_800,
        primaryColorLight: colors.indigo_primary_500,
        canvasColor: colors.indigo_primary_500,
        scaffoldBackgroundColor: colors.indigo_primary_500,
        textTheme: textTheme.apply(
          bodyColor: colors.black_tertiary_800,
          displayColor: colors.white_onPrimary_100,
        ),
        colorScheme: ColorScheme(
            brightness: brightness,
            primary: colors.indigo_primary_800,
            onPrimary: colors.white_onPrimary_100,
            primaryContainer: colors.indigo_primary_500,
            secondary: colors.lemon_secondary_800,
            onSecondary: colors.black_onSecondary_100,
            secondaryContainer: colors.lemon_secondary_500,
            onSecondaryContainer: colors.black_onSecondary_100,
            error: colors.red_error_500,
            onError: colors.white_onPrimary_100,
            surface: colors.light_container_500,
            onSurface: colors.grey_font_700),
      );
}

class ColorFamily {
  const ColorFamily({
    required this.indigo_primary_800,
    required this.indigo_primary_700,
    required this.indigo_primary_500,
    required this.indigo_primary_400,
    required this.indigo_primary_200,
    required this.indigo_primary_100,
    required this.white_onPrimary_100,
    required this.lemon_secondary_800,
    required this.lemon_secondary_700,
    required this.lemon_secondary_500,
    required this.lemon_secondary_400,
    required this.lemon_secondary_200,
    required this.lemon_secondary_100,
    required this.black_onSecondary_100,
    required this.lilac_tertiary_200,
    required this.black_tertiary_800,
    required this.red_error_500,
    required this.green_sucess_500,
    required this.light_container_500,
    required this.grey_font_700,
    required this.grey_font_500,
  });

  final Color indigo_primary_800;
  final Color indigo_primary_700;
  final Color indigo_primary_500;
  final Color indigo_primary_400;
  final Color indigo_primary_200;
  final Color indigo_primary_100;
  final Color white_onPrimary_100;

  final Color lemon_secondary_800;
  final Color lemon_secondary_700;
  final Color lemon_secondary_500;
  final Color lemon_secondary_400;
  final Color lemon_secondary_200;
  final Color lemon_secondary_100;
  final Color black_onSecondary_100;

  final Color lilac_tertiary_200;
  final Color black_tertiary_800;
  final Color red_error_500;
  final Color green_sucess_500;

  final Color light_container_500;
  final Color grey_font_700;
  final Color grey_font_500;
}
