import 'package:SmartTrainer/connections/repository/avaliacao_fisica_repository.dart';
import 'package:SmartTrainer/models/entity/avaliacao_fisica.dart';

class AvaliacaoFisicaController {
  final AvaliacaoFisicaRepository _avaliacaoRepository;

  AvaliacaoFisicaController({AvaliacaoFisicaRepository? avaliacaoRepository})
      : _avaliacaoRepository =
            avaliacaoRepository ?? AvaliacaoFisicaRepository();

  Future<bool> cadastrarAvaliacaoOnline({
    required AvaliacaoFisica avaliacaoFisica,
    required int altura,
    required double peso,
    required double pescoco,
    required double cintura,
    required double quadril,
  }) async {
    try {
      avaliacaoFisica.altura = altura;
      avaliacaoFisica.peso = peso;
      avaliacaoFisica.medidaPescoco = pescoco;
      avaliacaoFisica.medidaCintura = cintura;
      avaliacaoFisica.medidaQuadril = quadril;
      avaliacaoFisica.calcularIndices();
      avaliacaoFisica.status = StatusAvaliacao.realizada;

      await _avaliacaoRepository.update(avaliacaoFisica);
    } catch (e) {
      return false;
    }
    return true;
  }
}
