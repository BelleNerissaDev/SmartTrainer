import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/utils/menu_icons_utils.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

class Menu extends StatelessWidget {
  final ColorFamily colorTheme;
  Menu({Key? key, required this.colorTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: colorTheme.light_container_500,
      child: ListView.separated(
        separatorBuilder: (context, index) {
          if (index == 0) return const SizedBox.shrink();
          return Divider(
            color: colorTheme.black_onSecondary_100.withOpacity(0.3),
            thickness: 1,
            height: 1,
          );
        },
        itemCount: RoutesNames.menuRoutes.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              padding: EdgeInsets.zero,
              color: colorTheme.light_container_500,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: colorTheme.indigo_primary_700,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: colorTheme.indigo_primary_700,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            RoutesNames route = RoutesNames.menuRoutes[index - 1];
            return ListTile(
              leading: MenuIconsUtils.getMenuIcon(
                route: route,
                iconColor: currentRoute == route.route
                    ? colorTheme.indigo_primary_700
                    : colorTheme.black_onSecondary_100,
              ),
              title: Text(
                route.pageName,
                style: Theme.of(context).textTheme.headline20px!.copyWith(
                      color: currentRoute == route.route
                          ? colorTheme.indigo_primary_700
                          : colorTheme.black_onSecondary_100,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                route.route,
                (route) => false,
              ),
            );
          }
        },
      ),
      width: MediaQuery.of(context).size.width * 0.55,
    );
  }
}
