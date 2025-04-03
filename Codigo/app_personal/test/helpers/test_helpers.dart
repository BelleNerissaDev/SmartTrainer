import 'package:SmartTrainer_Personal/config/notificacao_provider.dart';
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';

Map<String, Widget Function(BuildContext)> generateTestRoutes() {
  return {
    for (var route in RoutesNames.values) route.route: (context) => route.page,
  };
}

Widget createWidgetUnderTest({
  required Widget child,
  NotificacaoProvider? provider,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => provider ?? NotificacaoProvider()),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: child,
      ),
      routes: generateTestRoutes(), // Usa a função para gerar rotas
    ),
  );
}
