import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/config/router.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/pages/controller/login_controller.dart';
import 'package:SmartTrainer/utils/menu_icons_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatelessWidget {
  final MyColorFamily colorTheme;
  const Menu({Key? key, required this.colorTheme}) : super(key: key);

  Color _iconColor(String currentRoute, String route) {
    return currentRoute == route
        ? colorTheme.indigo_primary_700
        : colorTheme.black_onSecondary_100;
  }

  @override
  Widget build(BuildContext context) {
    String? currentRoute = ModalRoute.of(context)?.settings.name;
    Aluno aluno = Provider.of<AlunoProvider>(context).aluno!;
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 160,
            child: DrawerHeader(
                child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 40,
                    child: aluno.imagem == null
                        ? const Icon(Icons.person)
                        : ClipOval(
                            child: Image.network(
                              aluno.imagem!,
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                            ),
                          ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(aluno.nome),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.menu),
                    color: colorTheme.indigo_primary_800,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.logout),
                    color: colorTheme.indigo_primary_800,
                    onPressed: () async {
                      await LoginController().logout();

                      Navigator.pushNamedAndRemoveUntil(
                          context, RoutesNames.login.route, (route) => false);
                    },
                  ),
                )
              ],
            )),
          ),
          for (RoutesNames route in RoutesNames.menuRoutes)
            ListTile(
              leading: Icon(MenuIconsUtils.menuIcons[route]),
              iconColor: _iconColor(currentRoute!, route.route),
              title: Text(route.pageName,
                  style: TextStyle(
                      color: _iconColor(currentRoute, route.route),
                      fontSize: 20)),
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, route.route, (route) => false),
            ),
        ],
      ),
      width: MediaQuery.of(context).size.width * 0.5,
    );
  }
}
