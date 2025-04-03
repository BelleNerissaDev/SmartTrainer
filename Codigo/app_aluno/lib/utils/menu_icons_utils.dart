import 'package:SmartTrainer/config/router.dart';
import 'package:flutter/material.dart';

class MenuIconsUtils {
  static final Map<RoutesNames, IconData> menuIcons = {
    RoutesNames.home: Icons.home,
    RoutesNames.treinos: Icons.fitness_center,
    RoutesNames.anamnese: Icons.account_box_outlined,
    RoutesNames.avaliacoes: Icons.star_border_sharp,
    RoutesNames.contato: Icons.chat_bubble_outline_sharp
  };
  static get getIcons => menuIcons;
}
