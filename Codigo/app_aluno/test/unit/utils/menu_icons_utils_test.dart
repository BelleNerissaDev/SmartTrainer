import 'package:SmartTrainer/config/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/utils/menu_icons_utils.dart';

void main() {
  test('MenuIconsUtils - getIcons should return the correct menu icons', () {
    final expectedIcons = {
      RoutesNames.home: Icons.home,
      RoutesNames.treinos: Icons.fitness_center,
      RoutesNames.anamnese: Icons.account_box_outlined,
      RoutesNames.avaliacoes: Icons.star_border_sharp,
      RoutesNames.contato: Icons.chat_bubble_outline_sharp,
    };

    final actualIcons = MenuIconsUtils.getIcons;

    expect(actualIcons, equals(expectedIcons));
  });
}
