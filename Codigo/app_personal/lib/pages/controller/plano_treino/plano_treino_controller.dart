import 'package:SmartTrainer_Personal/connections/repository/plano_treinos_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/plano.dart';

class PlanoTreinoController {
  final PlanoTreinoRepository _planoTreinoRepository;

  PlanoTreinoController({PlanoTreinoRepository? planoTreinoRepository})
      : _planoTreinoRepository =
            planoTreinoRepository ?? PlanoTreinoRepository();

  Future<void> criarPlanoTreino({
    required String alunoId,
    required PlanoTreino plano,
  }) async {
    try {
      // Chama o repository para criar o plano e seus treinos/exercícios
      await _planoTreinoRepository.createPlanoTreinos(
        alunoId: alunoId,
        plano: plano,
      );
    } catch (e) {
      throw Exception('Erro ao criar o plano de treino: $e');
    }
  }

  Future<void> editarPlanoTreino({
    required String alunoId,
    required String planoId,
    required PlanoTreino plano,
  }) async {
    try {
      // Chamando o repositório para editar o plano com os treinos e exercícios
      await _planoTreinoRepository.editPlanoTreinos(
        alunoId: alunoId,
        planoId: planoId,
        plano: plano,
      );
    } catch (e) {
      throw Exception('Erro ao editar o plano de treino: $e');
    }
  }

  Future<void> deletarPlanoTreino({
    required String alunoId,
    required String planoId,
  }) async {
    try {
      // Chama o repository para criar o plano e seus treinos/exercícios
      await _planoTreinoRepository.deletePlanoTreino(
        planoId: planoId,
        alunoId: alunoId,
      );
    } catch (e) {
      throw Exception('Erro ao criar o plano de treino: $e');
    }
  }

  Future<void> ativarPlanoTreino({
    required String alunoId,
    required String planoId,
  }) async {
    try {
      // Chama o repository para criar o plano e seus treinos/exercícios
      await _planoTreinoRepository.activatePlanoTreino(
        planoId: planoId,
        alunoId: alunoId,
      );
    } catch (e) {
      throw Exception('Erro ao desativar o plano de treino: $e');
    }
  }

  Future<List<PlanoTreino>> fetchPlanoTreinoAtivo(String alunoId) async {
    try {
      // Usando await para esperar a resposta da função readById
      List<PlanoTreino> planosTreino =
          await _planoTreinoRepository.getPlanoTreinoFromAluno(alunoId);

      return planosTreino; // Retornando a lista de planos de treino ativo
    } catch (e) {
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  Future<List<PlanoTreino>> fetchTodosPlanosTreinoAluno(String alunoId) async {
    try {
      // Usando await para esperar a resposta da função readById
      List<PlanoTreino> planosTreino =
          await _planoTreinoRepository.getAllPlanosTreinoFromAluno(alunoId);

      return planosTreino; // Retornando a lista de planos de treino ativo
    } catch (e) {
      return []; // Retorna uma lista vazia em caso de erro
    }
  }
}
