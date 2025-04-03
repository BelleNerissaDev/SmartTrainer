import 'package:SmartTrainer/config/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer/config/theme_provider.dart';

Map<String, Widget Function(BuildContext)> generateTestRoutes() {
  return {
    for (var route in RoutesNames.values) route.route: (context) => route.page,
  };
}

Widget createWidgetUnderTest({required Widget child}) {
  return ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: MaterialApp(
      home: Scaffold(
        body: child,
      ),
      routes: generateTestRoutes(), // Usa a função para gerar rotas
    ),
  );
}
