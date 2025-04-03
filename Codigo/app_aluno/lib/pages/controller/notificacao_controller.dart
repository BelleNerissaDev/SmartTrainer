import 'package:SmartTrainer/events/notification_service.dart';

class NotificacaoController {
  Future<void> receberNotificacao(Map<String, dynamic> data) async {
    NotificationService.showNotification(data);
  }
}
