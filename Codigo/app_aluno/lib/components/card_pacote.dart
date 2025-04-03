import 'package:SmartTrainer/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';

class CardPacote extends StatelessWidget {
  final double valor;
  final int acessos;
  final MyColorFamily colorTheme;

  const CardPacote({
    Key? key,
    required this.valor,
    required this.acessos,
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
                    Mdi.packageVariantClosed,
                    color: colorTheme.indigo_primary_700,
                  ),
                  Text('Pacote',
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
              child: Text('Valor (mês): R\$ ${valor.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: colorTheme.black_onSecondary_100,
                    fontSize: 14,
                  )),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text('Número de acessos (mês): $acessos',
                  style: TextStyle(
                    color: colorTheme.black_onSecondary_100,
                    fontSize: 14,
                  )),
            ),
          ],
        ),
      );
}
