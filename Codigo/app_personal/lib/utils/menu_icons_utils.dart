import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum IconType { material, svg }

class MenuIconsUtils {
  static final Map<RoutesNames, dynamic> menuIcons = {
    RoutesNames.home: IconType.material,
    RoutesNames.pacotes: 'assets/icons/package.svg',
    RoutesNames.exercicios: IconType.material,
    RoutesNames.alunos: IconType.material,
    RoutesNames.gruposMusculares: 'assets/icons/muscle_menu.svg',
    RoutesNames.anamnese: IconType.material,
  };

  static final Map<RoutesNames, IconData> materialIcons = {
    RoutesNames.home: Icons.home,
    RoutesNames.pacotes: Icons.content_paste,
    RoutesNames.exercicios: Icons.fitness_center,
    RoutesNames.alunos: Icons.groups,
    RoutesNames.gruposMusculares: Icons.accessibility,
    RoutesNames.anamnese: Icons.account_box_outlined,
  };

  // Método para obter o ícone
  static Widget getMenuIcon({
    required RoutesNames route,
    required Color iconColor,
  }) {
    var icon = menuIcons[route];

    if (icon is String) {
      // Retorna um ícone SVG
      return SvgPicture.asset(
        icon,
        color: iconColor,
        width: 24.0,
        height: 24.0,
      );
    } else if (icon is IconType && icon == IconType.material) {
      // Retorna um ícone Material
      return Icon(
        materialIcons[route],
        color: iconColor,
      );
    }
    return const SizedBox
        .shrink(); // Retorna um widget vazio se o ícone não for encontrado
  }

  // Getters para os mapas
  static Map<RoutesNames, dynamic> get getMenuIcons => menuIcons;
  static Map<RoutesNames, IconData> get getMaterialIcons => materialIcons;
}
