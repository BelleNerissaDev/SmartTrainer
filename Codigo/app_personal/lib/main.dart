import 'dart:ui';

import 'package:SmartTrainer_Personal/config/notificacao_provider.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/connections/provider/amqp.dart';
import 'package:SmartTrainer_Personal/events/notificacao_service.dart';
import 'package:SmartTrainer_Personal/pages/controller/notificacao/notificacao_controller.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:SmartTrainer_Personal/fonts.dart';
import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/config/router.dart';

import 'package:SmartTrainer_Personal/firebase_options.dart';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> initializeSharedResources() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!dotenv.isInitialized) {
    await dotenv.load(fileName: '.env');
  }

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await FirebaseAppCheck.instance.activate();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSharedResources();

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  // Define a orientação padrão como 'portraitUp' para o app inteiro
  await FirebaseAppCheck.instance.activate();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => notificacaoProvider),
      ],
      child: const MyApp(),
    ),
  );
  await NotificacaoController().loadNotificacoes();
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
  service.on('notificationReceived').listen((event) async {
    await NotificacaoController().loadNotificacoes();
  });
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

  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Amqp.startListening(
    'notificacoes_personal',
    (
      Map<dynamic, dynamic> message,
    ) {
      NotificacaoController()
          .receberNotificacao(message as Map<String, dynamic>);
      service.invoke(
        'notificationReceived',
      );
    },
  );
  NotificationService.showNotification({
    'nomeAluno': 'SmartTrainer Personal',
    'topico': 'notificações',
    'mensagem': 'está pronto para receber notificações',
  });
}

class MyApp extends StatelessWidget {
  final String? initialRoute;
  const MyApp({super.key, this.initialRoute});

  @override
  Widget build(BuildContext context) {
    // Mover a chamada para fora do ciclo de construção
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final brightness = View.of(context).platformDispatcher.platformBrightness;
      Provider.of<ThemeProvider>(context, listen: false)
          .updateTheme(brightness);
    });

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, 'Montserrat', 'Montserrat');
    CustomTheme theme = CustomTheme(textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Personal',
      theme: theme.theme(CustomTheme.colorFamilyLight, Brightness.light),
      darkTheme: theme.theme(CustomTheme.colorFamilyDark, Brightness.dark),
      routes: Routes.route(context),
      initialRoute: initialRoute ?? RoutesNames.loading.route,
    );
  }
}
