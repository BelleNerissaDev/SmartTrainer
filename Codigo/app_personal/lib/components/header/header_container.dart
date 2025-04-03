import 'package:SmartTrainer_Personal/fonts.dart';
import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:flutter/material.dart';

class HeaderContainer extends StatelessWidget {
  final String title;
  final ColorFamily colorTheme;

  const HeaderContainer({
    Key? key,
    required this.colorTheme,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.headline24px!.copyWith(
                color: colorTheme.white_onPrimary_100,
                fontWeight: FontWeight.bold),
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
