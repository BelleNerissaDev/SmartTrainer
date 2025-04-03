import 'package:SmartTrainer_Personal/fonts.dart';

import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeadlineTitles extends StatelessWidget {
  final String title;
  final String subtile;

  const HeadlineTitles({
    Key? key,
    required this.title,
    this.subtile = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;
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
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                subtile,
                style: Theme.of(context).textTheme.body14px!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: colorTheme.grey_font_700,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}
