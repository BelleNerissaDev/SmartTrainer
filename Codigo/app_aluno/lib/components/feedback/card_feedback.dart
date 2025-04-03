import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/input/text_input.dart';
import 'package:SmartTrainer/components/radio_button/icon_radio_button_group.dart';
import 'package:SmartTrainer/models/entity/nivel_esforco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_svg/svg.dart';

class CardFeedback extends StatelessWidget {
  final MyColorFamily colorTheme;
  final NivelEsforco nivelEsforco;
  final void Function(int) onNivelEsforcoChanged;
  final TextEditingController controller;
  final bool editavel;
  const CardFeedback({
    Key? key,
    required this.colorTheme,
    required this.nivelEsforco,
    required this.onNivelEsforcoChanged,
    required this.controller,
    required this.editavel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/svg/treino_completo.svg',
                height: 200.0,
                width: 200.0,
              ),
            ),
            const Text(
              'Treino completo!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Avalie seu nível de esforço do treino',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            Container(
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: colorTheme.white_onPrimary_100,
              ),
              padding: const EdgeInsets.all(8.0),
              child: IconRadioGroup(
                colorTheme: colorTheme,
                icons: [
                  Mdi.emoticonCoolOutline,
                  Mdi.emoticonWinkOutline,
                  Mdi.emoticonNeutralOutline,
                  Mdi.emoticonFrownOutline,
                  Mdi.emoticonDeadOutline,
                ],
                selectedIconIndex: nivelEsforco.value,
                onIconSelected: editavel ? onNivelEsforcoChanged : (e) {},
                iconSize: 40.0,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Observações',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),
            MultilineTextField(
              controller: controller,
              colorTheme: colorTheme,
              obscureText: false,
              enabled: editavel,
            )
          ],
        ),
      ),
    );
  }
}
