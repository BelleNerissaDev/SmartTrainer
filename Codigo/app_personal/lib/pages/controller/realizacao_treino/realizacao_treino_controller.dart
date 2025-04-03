import 'package:SmartTrainer_Personal/connections/repository/realizacao_treino_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';

class RealizacaoTreinoController {
  final RealizacaoTreinoRepository _realizacaoTreinoRepository;

  RealizacaoTreinoController(
      {RealizacaoTreinoRepository? realizacaoTreinoRepository})
      : _realizacaoTreinoRepository =
            realizacaoTreinoRepository ?? RealizacaoTreinoRepository();

  Future<List<DateTime>> fetchDatasDeRealizacaoTreino(Aluno aluno) async {
    try {
      List<DateTime> datasDeRealizacaoTreino = await _realizacaoTreinoRepository
          .readDatasRealizacaoUltimosMeses(aluno);

      return datasDeRealizacaoTreino;
    } catch (e) {
      return [];
    }
  }
}
