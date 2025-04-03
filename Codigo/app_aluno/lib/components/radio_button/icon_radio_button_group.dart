import 'package:SmartTrainer/app_theme.dart';
import 'package:flutter/material.dart';

class IconRadioGroup extends StatelessWidget {
  final MyColorFamily colorTheme;
  final List<IconData> icons;
  final int selectedIconIndex;
  final void Function(int) onIconSelected;
  final double iconSize;

  IconRadioGroup({
    Key? key,
    required this.icons,
    required this.selectedIconIndex,
    required this.onIconSelected,
    required this.colorTheme,
    this.iconSize = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(icons.length, (index) {
        return GestureDetector(
          onTap: () {
            onIconSelected(index);
          },
          child: Icon(
            icons[index],
            color: selectedIconIndex == index
                ? colorTheme.indigo_primary_400
                : colorTheme.gray_500,
            size: iconSize,
          ),
        );
      }),
    );
  }
}
