import 'package:SmartTrainer_Personal/config/notificacao_provider.dart';
import 'package:SmartTrainer_Personal/connections/repository/notificacao_repository.dart';
import 'package:SmartTrainer_Personal/events/notificacao_service.dart';

class NotificacaoController {
  final NotificacaoRepository _notificacaoRepository;

  NotificacaoController({NotificacaoRepository? notificacaoRepository})
      : _notificacaoRepository =
            notificacaoRepository ?? NotificacaoRepository();

  Future<void> receberNotificacao(Map<String, dynamic> data) async {
    NotificationService.showNotification(data);
    if (data['dateTime'] is String) {
      final date = DateTime.parse(data['dateTime']);
      data['dateTime'] = date;
    }
    _notificacaoRepository.create(data);
  }

  Future<void> loadNotificacoes() async {
    final notificacoes = await _notificacaoRepository.readAll();
    notificacaoProvider.clearNotifications();
    notificacoes.forEach((e) => notificacaoProvider.addNotification(e));
  }
}
