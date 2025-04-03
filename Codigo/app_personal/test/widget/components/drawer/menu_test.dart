import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/components/drawers/menu.dart';
import 'package:SmartTrainer_Personal/utils/menu_icons_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('Menu Widget Tests', () {
    testWidgets('renders menu items with correct icons and titles',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(builder: (context) {
          var colorTheme = CustomTheme.colorFamilyLight;
          return Menu(colorTheme: colorTheme);
        }),
      ));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Pacotes'), findsOneWidget);
      expect(find.text('Exercícios'), findsOneWidget);
      expect(find.text('Alunos'), findsOneWidget);
      expect(find.text('Grupos Musculares'), findsOneWidget);
      expect(find.text('Anamnese'), findsOneWidget);

      for (var route in RoutesNames.menuRoutes) {
        expect(find.text(route.pageName), findsOneWidget);
      }

      for (var route in RoutesNames.menuRoutes) {
        final iconType = MenuIconsUtils.getMenuIcons[route];
        if (iconType is IconType && iconType == IconType.material) {
          expect(find.byIcon(MenuIconsUtils.getMaterialIcons[route]!),
              findsOneWidget);
        } else if (iconType is String) {
          expect(find.byType(SvgPicture), findsWidgets);
        }
      }

      // TODO: Verificar a cor do ícone selecionado
      // // Verifica a cor do ícone selecionado para o item do menu atual
      // final selectedRoute =
      //     RoutesNames.home;
      // final selectedIcon = find.byIcon(Menu().materialIcons[selectedRoute]);
      // final selectedIconWidget = tester.widget<Icon>(selectedIcon);
      // expect(selectedIconWidget.color, equals(colorTheme.indigo_primary_700))
    });
  });
}
