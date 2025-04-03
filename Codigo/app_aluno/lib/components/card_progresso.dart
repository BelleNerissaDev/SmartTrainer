import 'package:SmartTrainer/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CardProgresso extends StatelessWidget {
  final int sessoesRealizadas;
  final int sessoesTotais;
  final MyColorFamily colorTheme;

  const CardProgresso({
    Key? key,
    required this.sessoesRealizadas,
    required this.sessoesTotais,
    required this.colorTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Column(
            children: [
              const Center(
                child: Text(
                  'Progresso',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: RichText(
                  text: TextSpan(
                    text: 'Sessões: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorTheme.black_onSecondary_100,
                    ),
                    children: [
                      TextSpan(
                        text: '$sessoesRealizadas',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                          color: colorTheme.indigo_primary_800,
                        ),
                      ),
                      TextSpan(
                        text: '/$sessoesTotais',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40),
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final percent = sessoesTotais > 0
                          ? sessoesRealizadas / sessoesTotais
                          : 0.0; // Evita divisão por zero

                      return LinearPercentIndicator(
                        progressColor: colorTheme.indigo_primary_800,
                        backgroundColor: colorTheme.white_onPrimary_100,
                        percent: percent,
                        lineHeight: 10,
                        animation: true,
                        curve: Curves.easeInOut,
                        barRadius: const Radius.circular(5),
                        widgetIndicator: percent > 0
                            ? Transform.translate(
                                offset: const Offset(0, -30),
                                child: Text(
                                  '${(percent * 100).toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    color: colorTheme.indigo_primary_800,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              )
                            : null,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
