import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/fonts.dart';
import 'package:flutter/material.dart';

class HeadlineTitles extends StatelessWidget {
  final String title;
  final String subtile;
  final MyColorFamily colorTheme;

  const HeadlineTitles({
    Key? key,
    required this.title,
    required this.colorTheme,
    this.subtile = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline20px!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorTheme.black_onSecondary_100,
                ),
          ),
        ),
        if (subtile != '')
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                subtile,
                style: Theme.of(context).textTheme.body14px!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: colorTheme.gray_800,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}
