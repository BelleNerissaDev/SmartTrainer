import 'package:SmartTrainer/app_theme.dart';
import 'package:flutter/material.dart';

class CardLoginSemanal extends StatelessWidget {
  final MyColorFamily colorTheme;
  final int diaSemana;
  final int acessos;
  const CardLoginSemanal({
    Key? key,
    required this.colorTheme,
    required this.diaSemana,
    required this.acessos,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        color: colorTheme.indigo_primary_100,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: RichText(
                text: TextSpan(
              children: [
                TextSpan(
                  text: 'Login Semanal ',
                  style: TextStyle(
                    color: colorTheme.black_onSecondary_100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                    text: '$diaSemana',
                    style: TextStyle(
                        color: colorTheme.indigo_primary_700,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                  text: ' de $acessos',
                  style: TextStyle(
                    color: colorTheme.black_onSecondary_100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ))),
      ),
    );
  }
}
