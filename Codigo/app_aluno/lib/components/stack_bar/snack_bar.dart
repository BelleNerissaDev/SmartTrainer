import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showSnackBar({required context, required message, bool error = false}) {
  var colorTheme =
      Provider.of<ThemeProvider>(context, listen: false).colorTheme;
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor:
        error ? colorTheme.red_error_500 : colorTheme.green_sucess_500,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
