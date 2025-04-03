import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/utils/error_message.dart';
import 'package:flutter/material.dart';

class ObscuredTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final double paddingVertical;
  final double paddingHorizontal;
  final Color? backgroundColor;
  final Color? textColor;
  final List<ErrorMessage> errors;
  final bool showErrors;
  final MyColorFamily colorTheme;
  final bool enabled;

  const ObscuredTextField({
    Key? key,
    this.label = '',
    required this.controller,
    required this.colorTheme,
    this.obscureText = true,
    this.paddingVertical = 8.0,
    this.paddingHorizontal = 8.0,
    this.backgroundColor,
    this.textColor,
    this.errors = const [],
    this.showErrors = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasError = errors.isNotEmpty && showErrors;

    return Column(
      children: [
        TextField(
          obscureText: obscureText,
          enabled: enabled,
          controller: controller,
          style: TextStyle(
            color: textColor ?? colorTheme.black_onSecondary_100,
            decorationColor: colorTheme.gray_700,
          ),
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: backgroundColor ?? colorTheme.white_onPrimary_100,
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color:
                    hasError ? colorTheme.red_error_500 : colorTheme.gray_700,
                width: 1.0,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: hasError
                    ? colorTheme.red_error_500
                    : colorTheme.indigo_primary_500,
                width: 2.0,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color:
                    hasError ? colorTheme.red_error_500 : colorTheme.gray_500,
                width: 2.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal, vertical: paddingVertical),
          ),
        ),
        if (errors.isNotEmpty && showErrors)
          for (final error in errors)
            Text(
              error.message,
              style: TextStyle(
                color: error.error
                    ? colorTheme.red_error_500
                    : colorTheme.green_sucess_500,
              ),
            ),
      ],
    );
  }
}


class MultilineTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final double paddingVertical;
  final double paddingHorizontal;
  final Color? backgroundColor;
  final Color? textColor;
  final List<ErrorMessage> errors;
  final bool showErrors;
  final MyColorFamily colorTheme;
  final bool enabled;

  const MultilineTextField({
    Key? key,
    this.label = '',
    required this.controller,
    required this.colorTheme,
    this.obscureText = true,
    this.paddingVertical = 8.0,
    this.paddingHorizontal = 8.0,
    this.backgroundColor,
    this.textColor,
    this.errors = const [],
    this.showErrors = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasError = errors.isNotEmpty && showErrors;

    return Column(
      children: [
        TextField(
          maxLines: null,
          obscureText: obscureText,
          enabled: enabled,
          controller: controller,
          style: TextStyle(
            color: textColor ?? colorTheme.black_onSecondary_100,
            decorationColor: colorTheme.gray_700,
          ),
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: backgroundColor ?? colorTheme.white_onPrimary_100,
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color:
                    hasError ? colorTheme.red_error_500 : colorTheme.gray_700,
                width: 1.0,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: hasError
                    ? colorTheme.red_error_500
                    : colorTheme.indigo_primary_500,
                width: 2.0,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color:
                    hasError ? colorTheme.red_error_500 : colorTheme.gray_500,
                width: 2.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal, vertical: paddingVertical),
          ),
        ),
        if (errors.isNotEmpty && showErrors)
          for (final error in errors)
            Text(
              error.message,
              style: TextStyle(
                color: error.error
                    ? colorTheme.red_error_500
                    : colorTheme.green_sucess_500,
              ),
            ),
      ],
    );
  }
}
