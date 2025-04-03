import 'package:SmartTrainer_Personal/fonts.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/app_theme.dart'; // Importando o tema personalizado

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ColorFamily colorTheme;
  final Widget? leading;

  const CustomAppBar({
    Key? key,
    required this.colorTheme,
    required this.title, // Cor padrão caso não seja especificada
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: colorTheme.indigo_primary_500,
      iconTheme: IconThemeData(
        color: colorTheme.white_onPrimary_100, // Cor do ícone
        size: 30, // Tamanho do ícone
      ),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline24px!
            .copyWith(color: colorTheme.white_onPrimary_100),
      ),
      centerTitle: true,
      leading: leading,
      actions: [
        IconButton(
          icon:
              Icon(Icons.notifications, color: colorTheme.white_onPrimary_100),
          onPressed: () {
            // Defina a lógica para o botão de notificações
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }

  // Este método é necessário para definir a altura da AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
