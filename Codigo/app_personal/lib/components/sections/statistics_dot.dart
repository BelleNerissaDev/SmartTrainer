import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

class StatisticsDot extends StatelessWidget {
  final String title;
  final int count;
  final Color backgroundColor;
  final Color textColor;
  final ColorFamily colorTheme;

  const StatisticsDot({
    Key? key,
    required this.title,
    required this.count,
    required this.backgroundColor,
    required this.textColor,
    required this.colorTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 60, // Tamanho fixo do círculo
          height: 60, // Tamanho fixo do círculo
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
          ),
          child: Text(
            '$count',
            style: Theme.of(context).textTheme.headline20px!.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title14px!.copyWith(
                color: colorTheme.black_onSecondary_100,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    ));
  }
}
