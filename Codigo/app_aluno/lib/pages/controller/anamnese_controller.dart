import 'package:SmartTrainer/connections/repository/anamnese_repository.dart';
import 'package:SmartTrainer/models/entity/anamnese.dart';
import 'package:SmartTrainer/models/entity/sexo.dart';

class AnamneseController {
  final AnamneseRepository _anamneseRepository;

  AnamneseController({AnamneseRepository? anamneseRepository})
      : _anamneseRepository = anamneseRepository ?? AnamneseRepository();

  Future<bool> criarAnamnese({
    required String idAluno,
    required String nomeCompleto,
    required String email,
    required DateTime data,
    String? nomeResponsavel,
    required int idade,
    required Sexo sexo,
    required String telefone,
    required StatusAnamneseEnum status,
    required String nomeContatoEmergencia,
    required String telefoneContatoEmergencia,
    required RespostasParq respostasParq,
    required RespostasHistSaude respostasHistSaude,
  }) async {
    try {
      final Anamnese anamnese = Anamnese(
        nomeCompleto: nomeCompleto,
        email: email,
        data: data,
        nomeResponsavel: nomeResponsavel,
        idade: idade,
        sexo: sexo,
        telefone: telefone,
        status: status,
        nomeContatoEmergencia: nomeContatoEmergencia,
        telefoneContatoEmergencia: telefoneContatoEmergencia,
        respostasParq: respostasParq,
        respostasHistSaude: respostasHistSaude,
      );

      await _anamneseRepository.createAnamnese(anamnese, idAluno);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editarAnamense({
    required String id,
    required String idAluno,
    required String nomeCompleto,
    required String email,
    required DateTime data,
    String? nomeResponsavel,
    required int idade,
    required Sexo sexo,
    required String telefone,
    required StatusAnamneseEnum status,
    required String nomeContatoEmergencia,
    required String telefoneContatoEmergencia,
    required RespostasParq respostasParq,
    required RespostasHistSaude respostasHistSaude,
  }) async {
    try {
      final Anamnese anamnese = Anamnese(
        id: id,
        nomeCompleto: nomeCompleto,
        email: email,
        data: data,
        nomeResponsavel: nomeResponsavel,
        idade: idade,
        sexo: sexo,
        telefone: telefone,
        status: status,
        nomeContatoEmergencia: nomeContatoEmergencia,
        telefoneContatoEmergencia: telefoneContatoEmergencia,
        respostasParq: respostasParq,
        respostasHistSaude: respostasHistSaude,
      );

      await _anamneseRepository.updateAnamnese(anamnese, idAluno);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Anamnese?> visualizarAnamnesePorId(String id) async {
    try {
      return await _anamneseRepository.readById(id);
    } catch (e) {
      return null;
    }
  }

  Future<Anamnese?> carregarAnamnese(String idAluno) async {
    try {
      final anamnese = await _anamneseRepository.getLastAnamnese(idAluno);
      if (anamnese != null) {
        return anamnese;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Erro ao visualizar anamnese: $e');
    }
  }
}
