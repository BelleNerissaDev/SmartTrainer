import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

// Botão personalizado reutilizável
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final String buttonType;
  final double horizontalPadding;
  final double verticalPadding;
  final IconData? icon; // Ícone opcional
  final Color? iconColor; // Cor do ícone opcional

  const PrimaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    this.textStyle,
    this.buttonType = 'primary',
    this.horizontalPadding = 60.0,
    this.verticalPadding = 8.0,
    this.icon, // Ícone opcional
    this.iconColor, // Cor do ícone opcional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;

    // Definir o estilo de texto padrão
    final defaultTextStyle = Theme.of(context).textTheme.headline20px!.copyWith(
          color: colorTheme.white_onPrimary_100,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        );

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: colorTheme.grey_font_500,
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? colorTheme.white_onPrimary_100,
            ),
            const SizedBox(width: 8.0),
          ],
          Text(
            label,
            style: textStyle ?? defaultTextStyle,
          ),
        ],
      ),
    );
  }
}
