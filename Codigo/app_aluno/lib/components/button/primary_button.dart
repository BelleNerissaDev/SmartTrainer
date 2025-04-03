import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer/fonts.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final String buttonType;
  final double horizontalPadding;
  final double verticalPadding;

  const PrimaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    this.textStyle,
    this.buttonType = 'primary',
    this.horizontalPadding = 60.0,
    this.verticalPadding = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;

    final defaultTextStyle = Theme.of(context).textTheme.headline20px!.copyWith(
          color: colorTheme.white_onPrimary_100,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        );

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: colorTheme.gray_500,
        elevation: 5.0,
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Text(
        label,
        style: textStyle ?? defaultTextStyle,
      ),
    );
  }
}
