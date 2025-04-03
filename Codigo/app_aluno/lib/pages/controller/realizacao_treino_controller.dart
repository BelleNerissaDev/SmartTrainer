import 'package:SmartTrainer/connections/repository/realizacao_treino_repository.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/feedback.dart';
import 'package:SmartTrainer/models/entity/nivel_esforco.dart';
import 'package:SmartTrainer/models/entity/realizacao_treino.dart';

class RealizacaoTreinoController {
  final RealizacaoTreinoRepository _realizacaoTreinoRepository;

  RealizacaoTreinoController({RealizacaoTreinoRepository? anamneseRepository})
      : _realizacaoTreinoRepository =
            anamneseRepository ?? RealizacaoTreinoRepository();

  Future<bool> criarRealizacaoTreino({
    required Aluno aluno,
    required RealizacaoTreino realizacaoTreino,
    required NivelEsforco nivelEsforco,
    required String observacao,
  }) async {
    try {
      final feedback = Feedback(
        nivelEsforco: nivelEsforco,
        observacao: observacao,
      );
      realizacaoTreino.feedback = feedback;

      await _realizacaoTreinoRepository.create(aluno, realizacaoTreino);

      return true;
    } catch (e) {
      return false;
    }
  }
}
