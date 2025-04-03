import 'dart:ui';

import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/connections/provider/amqp.dart';
import 'package:SmartTrainer/events/notification_service.dart';
import 'package:SmartTrainer/firebase_options.dart';
import 'package:SmartTrainer/fonts.dart';
import 'package:SmartTrainer/pages/controller/notificacao_controller.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:SmartTrainer/config/router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  await dotenv.load(fileName: '.env');
  await initializeDateFormatting();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AlunoProvider()),
      ],
      child: const MyApp(),
    ),
  );
  await initializeService();
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      foregroundServiceTypes: [AndroidForegroundType.dataSync],
      initialNotificationContent: 'SmartTrainer está rodando em segundo plano',
      initialNotificationTitle: 'SmartTrainer',
    ),
    iosConfiguration: IosConfiguration(),
  );
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? alunoId = preferences.getString('userId');

  while (alunoId == null) {
    alunoId = preferences.getString('userId');
    await Future.delayed(const Duration(seconds: 10));
    await preferences.reload();
  }

  await dotenv.load(fileName: '.env');
  await Amqp.startListening(alunoId, (Map<dynamic, dynamic> message) {
    NotificacaoController().receberNotificacao(message as Map<String, dynamic>);
  });

  NotificationService.showNotification({
    'nomeAluno': 'SmartTrainer',
    'topico': 'notificações',
    'mensagem': 'está pronto para receber notificações',
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    // final brightness = Brightness.light;
    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, 'Montserrat', 'Montserrat');

    CustomTheme theme = CustomTheme(textTheme);

    return Builder(
      builder: (context) {
        var colorFamily = brightness == Brightness.light
            ? CustomTheme.colorFamilyLight
            : CustomTheme.colorFamilyDark;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'App Personal',
          theme: theme.theme(colorFamily, Brightness.light),
          darkTheme: theme.theme(colorFamily, Brightness.dark),
          routes: Routes.route(context),
          initialRoute: RoutesNames.login.route,
        );
      },
    );
  }
}
