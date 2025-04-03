import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/app_theme.dart';

class CardContainer extends StatelessWidget {
  final ColorFamily colorTheme;
  final Widget child;

  const CardContainer({
    Key? key,
    required this.colorTheme,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorTheme.white_onPrimary_100,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2), // Muda a posição da sombra
          ),
        ],
      ),
      child: child,
    );
  }
}
