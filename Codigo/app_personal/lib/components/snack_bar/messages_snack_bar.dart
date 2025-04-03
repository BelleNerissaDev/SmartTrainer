import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

void showMessageSnackBar(colorTheme, context, message, {bool error = false}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: Theme.of(context).textTheme.title16px!.copyWith(
            color: colorTheme.white_onPrimary_100,
            fontWeight: FontWeight.w700,
          ),
    ),
    backgroundColor:
        error ? colorTheme.red_error_500 : colorTheme.green_sucess_500,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
