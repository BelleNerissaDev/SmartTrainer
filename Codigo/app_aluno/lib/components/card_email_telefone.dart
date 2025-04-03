import 'package:SmartTrainer/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';

class CardEmailTelefone extends StatelessWidget {
  final MyColorFamily colorTheme;
  final String email;
  final String telefone;

  const CardEmailTelefone({
    Key? key,
    required this.colorTheme,
    required this.email,
    required this.telefone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(Mdi.phone, color: colorTheme.indigo_primary_700),
                  Text(
                    telefone,
                    style: TextStyle(
                      color: colorTheme.black_onSecondary_100,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Mdi.emailOutline, color: colorTheme.indigo_primary_700),
                  Text(
                    email,
                    style: TextStyle(
                      color: colorTheme.black_onSecondary_100,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Divider(
              color: colorTheme.black_onSecondary_100,
              thickness: 1,
            ),
          ),
        ],
      );
}
