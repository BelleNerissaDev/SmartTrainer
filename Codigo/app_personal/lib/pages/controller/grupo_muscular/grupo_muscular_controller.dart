import 'package:SmartTrainer_Personal/connections/repository/grupo_muscular_repository.dart';
import 'package:SmartTrainer_Personal/connections/repository/exercicio_generico_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';

class GrupoMuscularController {
  final GrupoMuscularRepository _grupoMuscularRepository;
  final ExercicioGenericoRepository _exercicioGenericoRepository;

  GrupoMuscularController(
      {GrupoMuscularRepository? grupoMuscularRepository,
      ExercicioGenericoRepository? exercicioGenericoRepository})
      : _grupoMuscularRepository =
            grupoMuscularRepository ?? GrupoMuscularRepository(),
        _exercicioGenericoRepository =
            exercicioGenericoRepository ?? ExercicioGenericoRepository();

  Future<List<GrupoMuscular>> visualizarGruposMusculares() async {
    try {
      final List<GrupoMuscular> grupos =
          await _grupoMuscularRepository.readAll();
      return grupos;
    } catch (e) {
      throw Exception('Erro ao visualizar grupos musculares: $e');
    }
  }

  Future<List<Exercicio>> visualizarExerciciosPorGrupoMuscular(
      List<String> gruposMusculares) async {
    try {
      final List<Exercicio> grupos = await _exercicioGenericoRepository
          .readByGrupoMuscular(gruposMusculares);
      return grupos;
    } catch (e) {
      throw Exception('Erro ao visualizar exercícios: $e');
    }
  }

  Future<void> atualizarGrupoMuscularEmExercicio(
      String grupoMuscularId, String exercicioId,
      {required bool isAdding}) async {
    try {
      await _exercicioGenericoRepository.updateGrupoMuscularInExercicio(
          grupoMuscularId, exercicioId,
          isAdding: isAdding);
    } catch (e) {
      throw Exception('Erro ao visualizar exercícios: $e');
    }
  }
}
