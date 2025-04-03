import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/utils/error_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ObscuredTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController controller;
  final bool obscureText;
  final double paddingVertical;
  final double paddingHorizontal;
  final Color? backgroundColor; // Cor de fundo opcional
  final Color? textColor;
  final List<ErrorMessage> errors;
  final bool showErrors;
  final ColorFamily colorTheme;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool hasBorder;
  final bool textCenter;
  final void Function()? onEditingComplete;

  const ObscuredTextField({
    Key? key,
    this.label,
    this.hintText,
    required this.controller,
    required this.colorTheme,
    this.obscureText = true,
    this.paddingVertical = 8.0,
    this.paddingHorizontal = 8.0,
    this.backgroundColor,
    this.textColor,
    this.errors = const [],
    this.showErrors = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.hasBorder = true,
    this.textCenter = false,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Verifica se há erros
    bool hasError = errors.isNotEmpty && showErrors;

    return Column(
      children: [
        TextField(
          textAlign: textCenter ? TextAlign.center : TextAlign.start,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          obscureText: obscureText,
          controller: controller,
          style: TextStyle(
            color: textColor ?? colorTheme.black_onSecondary_100,
            decorationColor: colorTheme.grey_font_700,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            labelText: label,
            filled: true, // Ativa o preenchimento de cor de fundo
            fillColor: backgroundColor ?? colorTheme.white_onPrimary_100,
            border: hasBorder
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: hasError
                          ? colorTheme
                              .red_error_500 // Cor vermelha em caso de erro
                          : colorTheme.grey_font_700,
                      width: 1.0,
                    ),
                  )
                : InputBorder.none,
            focusedBorder: hasBorder
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: hasError
                          ? colorTheme.red_error_500
                          : colorTheme.indigo_primary_500,
                      width: 2.0,
                    ),
                  )
                : InputBorder.none,
            enabledBorder: hasBorder
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: hasError
                          ? colorTheme.red_error_500
                          : colorTheme.grey_font_500,
                      width: 2.0,
                    ),
                  )
                : InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal,
                vertical: paddingVertical), // Ajusta o padding interno
          ),
          onEditingComplete: onEditingComplete,
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
