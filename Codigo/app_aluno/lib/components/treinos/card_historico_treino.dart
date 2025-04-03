import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/radio_button/icon_radio_button_group.dart';
import 'package:SmartTrainer/models/entity/nivel_esforco.dart';
import 'package:SmartTrainer/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';

class CardHistoricoTreino extends StatelessWidget {
  final MyColorFamily colorTheme;
  final String titulo;
  final int tempo;
  final DateTime data;
  final NivelEsforco nivelEsforco;
  final String observacao;

  const CardHistoricoTreino({
    super.key,
    required this.colorTheme,
    required this.titulo,
    required this.tempo,
    required this.data,
    required this.nivelEsforco,
    required this.observacao,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text('${formatTime(tempo)} - ${formatDate(data)}'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text('Esforço: '),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: colorTheme.white_onPrimary_100,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: IconRadioGroup(
                          iconSize: 30,
                          colorTheme: colorTheme,
                          icons: [
                            Mdi.emoticonCoolOutline,
                            Mdi.emoticonWinkOutline,
                            Mdi.emoticonNeutralOutline,
                            Mdi.emoticonFrownOutline,
                            Mdi.emoticonDeadOutline,
                          ],
                          selectedIconIndex: nivelEsforco.value,
                          onIconSelected: (index) {},
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text('Observação: '),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: colorTheme.white_onPrimary_100,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text(observacao),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
