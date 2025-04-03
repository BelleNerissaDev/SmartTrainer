import 'package:SmartTrainer/connections/provider/amqp.dart';

class NotificacaoEvents {
  static const String channel = 'notificacoes_personal';

  static void notificarInicioTreino(String nomeAluno, String? imagemAluno) {
    Amqp.publishMessage(channel, {
      'nomeAluno': nomeAluno,
      'topico': 'treino',
      'mensagem': 'iniciou um treino',
      'dateTime': DateTime.now().toString(),
      'imagemAluno': imagemAluno,
    });
  }

  static void notificarCancelementoTreino(
      String nomeAluno, String? imagemAluno) {
    Amqp.publishMessage(channel, {
      'nomeAluno': nomeAluno,
      'topico': 'treino',
      'mensagem': 'cancelou um treino',
      'dateTime': DateTime.now().toString(),
      'imagemAluno': imagemAluno,
    });
  }

  static void notificarFimTreino(String nomeAluno, String? imagemAluno) {
    Amqp.publishMessage(channel, {
      'nomeAluno': nomeAluno,
      'topico': 'treino',
      'mensagem': 'finalizou um treino',
      'dateTime': DateTime.now().toString(),
      'imagemAluno': imagemAluno,
    });
  }

  static void notificarPrimeiroAcesso(String nomeAluno, String? imagemAluno) {
    Amqp.publishMessage(channel, {
      'nomeAluno': nomeAluno,
      'topico': 'login',
      'mensagem': 'realizou seu primeiro acesso',
      'dateTime': DateTime.now().toString(),
      'imagemAluno': imagemAluno,
    });
  }
}
