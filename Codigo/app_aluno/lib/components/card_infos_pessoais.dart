import 'package:SmartTrainer/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';

class CardInfosPessoais extends StatelessWidget {
  final int idade;
  final double peso;
  final int altura;
  final MyColorFamily colorTheme;

  const CardInfosPessoais({
    Key? key,
    required this.idade,
    required this.peso,
    required this.altura,
    required this.colorTheme,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => Container(
        height: 120,
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Icon(
                    Mdi.accountBoxOutline,
                    color: colorTheme.indigo_primary_700,
                  ),
                  Text('Informações pessoais',
                      style: TextStyle(
                        color: colorTheme.black_onSecondary_100,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      )),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Idade: $idade anos',
                  style: TextStyle(
                    color: colorTheme.black_onSecondary_100,
                    fontSize: 14,
                  )),
            ),
            Align(
              alignment: Alignment.center,
              child: Text('Altura: $altura cm',
                  style: TextStyle(
                    color: colorTheme.black_onSecondary_100,
                    fontSize: 14,
                  )),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text('Peso: $peso kg',
                  style: TextStyle(
                    color: colorTheme.black_onSecondary_100,
                    fontSize: 14,
                  )),
            ),
          ],
        ),
      );
}
