import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/utils/error_message.dart';
import 'package:flutter/material.dart';

class NumberInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final MyColorFamily colorTheme;

  final List<ErrorMessage> errors;
  final bool showErrors;

  const NumberInputField({
    required this.label,
    required this.colorTheme,
    required this.controller,
    this.errors = const [],
    this.showErrors = false,
  });

  @override
  Widget build(BuildContext context) {
    // Verifica se há erros
    String? errorText;
    if (showErrors && errors.isNotEmpty) {
      errorText = errors.firstWhere((error) => error.error).message;
    }

    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        fillColor: colorTheme.lilac_tertiary_200,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: colorTheme.indigo_primary_500),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: colorTheme.red_error_500),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: colorTheme.red_error_500),
        ),
        errorText: errorText,
        hintText: label,
        hintStyle: TextStyle(color: colorTheme.black_onSecondary_100),
      ),
    );
  }
}
