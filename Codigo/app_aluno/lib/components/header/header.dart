import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/header/card_nome_aluno.dart';
import 'package:SmartTrainer/config/router.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final MyColorFamily colorTheme;
  final Widget? leading;

  const Header({
    Key? key,
    required this.colorTheme,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: colorTheme.white_onPrimary_100,
      iconTheme: IconThemeData(
        color: colorTheme.indigo_primary_800, // Cor do ícone
        size: 30, // Tamanho do ícone
      ),
      centerTitle: true,
      leading: leading,
      actions: [
        IconButton(
          icon: CardNomeAluno(colorTheme: colorTheme),
          onPressed: () =>
              Navigator.pushNamed(context, RoutesNames.perfil.route),
        ),
      ],
    );
  }

  // Este método é necessário para definir a altura da AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
