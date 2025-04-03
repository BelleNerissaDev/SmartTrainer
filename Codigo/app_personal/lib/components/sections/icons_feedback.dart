import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';

// Componente para exibir ícones de feedback, destacando o selecionado
class IconsFeedback extends StatelessWidget {
  final ColorFamily colorTheme;
  final int? selectedIndex; // Índice do ícone que será destacado

  const IconsFeedback(
      {Key? key, required this.selectedIndex, required this.colorTheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<IconData> feedbackIcons = [
      Mdi.emoticonCoolOutline,
      Mdi.emoticonWinkOutline,
      Mdi.emoticonNeutralOutline,
      Mdi.emoticonFrownOutline,
      Mdi.emoticonDeadOutline,
    ];

    final int effectiveIndex = selectedIndex ?? 4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Centralizar os ícones
      children: List.generate(feedbackIcons.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 8.0), // Defina o espaçamento
          child: Icon(
            feedbackIcons[index],
            color: index == effectiveIndex
                ? colorTheme.indigo_primary_800
                : colorTheme.grey_font_500,
            size: 28,
          ),
        );
      }),
    );
  }
}
