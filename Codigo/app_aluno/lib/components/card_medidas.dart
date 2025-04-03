import 'package:SmartTrainer/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CardMedidas extends StatelessWidget {
  final int pescoco;
  final int cintura;
  final int quadril;
  final MyColorFamily colorTheme;

  const CardMedidas({
    Key? key,
    required this.pescoco,
    required this.cintura,
    required this.quadril,
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
                    Ionicons.body,
                    color: colorTheme.indigo_primary_700,
                  ),
                  Text('Medidas corporais',
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
              child: Text('Pescoço: $pescoco cm',
                  style: TextStyle(
                    color: colorTheme.black_onSecondary_100,
                    fontSize: 14,
                  )),
            ),
            Align(
              alignment: Alignment.center,
              child: Text('Quadril: $quadril cm',
                  style: TextStyle(
                    color: colorTheme.black_onSecondary_100,
                    fontSize: 14,
                  )),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text('Cintura: $cintura cm',
                  style: TextStyle(
                    color: colorTheme.black_onSecondary_100,
                    fontSize: 14,
                  )),
            ),
          ],
        ),
      );
}
