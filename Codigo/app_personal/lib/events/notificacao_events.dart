import 'package:SmartTrainer_Personal/connections/provider/amqp.dart';

class NotificacaoEvents {
  static void notificarSolicitacaoAvaliacao(
    String idAluno,
    String nomeAluno,
  ) {
    Amqp.publishMessage(idAluno, {
        'topico': 'avaliação',
        'nomeAluno': nomeAluno,
        'mensagem': 'tem uma nova solicitação de avaliação online',
      },
    );
  }

  static void notificarEnvioAvaliacao(
    String idAluno,
    String nomeAluno,
  ) {
    Amqp.publishMessage(idAluno, {
      'topico': 'avaliação',
        'nomeAluno': nomeAluno,
        'mensagem': 'tem um novo pdf de avaliação',
    },);
  }

  static void notificarSolicitacaoAnamnese(
    String idAluno,
    String nomeAluno,
  ) {
    Amqp.publishMessage(
      idAluno,
      {
        'nomeAluno': nomeAluno,
        'topico': 'anamnese',
        'mensagem': 'tem uma nova solicitação de anamnese',
      },
    );
  }
}
