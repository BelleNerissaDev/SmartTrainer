import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _notifications.initialize(settings);
  }

  static Future<void> showNotification(Map<dynamic, dynamic> payload) async {
    final androidDetails = AndroidNotificationDetails(
      payload['topico'],
      payload['topico'],
      icon: '@drawable/ic_notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    final notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    final title = 'Notificação de ${payload['topico']}';
    final body = '${payload['nomeAluno']} ${payload['mensagem']}';

    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
    );
  }
}
