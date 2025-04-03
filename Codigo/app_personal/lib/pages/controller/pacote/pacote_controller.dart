import 'package:SmartTrainer_Personal/connections/repository/pacote_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';

class PacoteController {
  final PacoteRepository _pacoteRepository;

  PacoteController({PacoteRepository? pacoteRepository})
      : _pacoteRepository = pacoteRepository ?? PacoteRepository();

  Future<bool> criarPacote({
    required String nome,
    required String valorMensal,
    required String numeroAcessos,
  }) async {
    try {
      final Pacote pacote = Pacote(
        nome: nome,
        valorMensal: valorMensal,
        numeroAcessos: numeroAcessos,
      );

      await _pacoteRepository.create(pacote);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editarPacote({
    required String nome,
    String? id,
    required String valorMensal,
    required String numeroAcessos,
  }) async {
    try {
      final Pacote pacote = Pacote(
        id: id,
        nome: nome,
        valorMensal: valorMensal,
        numeroAcessos: numeroAcessos,
      );

      await _pacoteRepository.update(pacote);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Pacote?> visualizarPacotePorId(String id) async {
    try {
      return await _pacoteRepository.readById(id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Pacote>> visualizarPacotes() async {
    try {
      final List<Pacote> pacotes = await _pacoteRepository.readAll();
      return pacotes;
    } catch (e) {
      throw Exception('Erro ao visualizar pacotes: $e');
    }
  }
}
