import 'package:SmartTrainer_Personal/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer_Personal/connections/repository/anamnese_repository.dart';
import 'package:SmartTrainer_Personal/events/notificacao_events.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/anamnese.dart';
import 'package:SmartTrainer_Personal/models/entity/sexo.dart';

class AnamneseController {
  final AnamneseRepository _anamneseRepository;
  final AlunoRepository _alunoRepository;

  AnamneseController(
      {AnamneseRepository? anamneseRepository,
      AlunoRepository? alunoRepository})
      : _anamneseRepository = anamneseRepository ?? AnamneseRepository(),
        _alunoRepository = alunoRepository ?? AlunoRepository();

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

  Future<bool> solicitarAnamnese(Aluno aluno) async {
    try {
      final Anamnese anamnese = Anamnese(
        nomeCompleto: '',
        email: aluno.email,
        data: DateTime.now(),
        idade: 0,
        sexo: Sexo.fromString(aluno.sexo),
        telefone: aluno.telefone,
        status: StatusAnamneseEnum.PEDENTE,
        nomeContatoEmergencia: '',
        telefoneContatoEmergencia: '',
        respostasParq: RespostasParq(
          respostas: {
            'testeParqQ1': '',
            'testeParqQ2': '',
            'testeParqQ3': '',
            'testeParqQ4': '',
            'testeParqQ5': '',
            'testeParqQ6': '',
            'testeParqQ7': '',
          },
        ),
        respostasHistSaude: RespostasHistSaude(
          respostas: {
            'testeHistSaudeQ1': '',
            'testeHistSaudeQ2': '',
            'testeHistSaudeQ3': '',
            'testeHistSaudeQ4': '',
            'testeHistSaudeQ5': '',
            'testeHistSaudeQ6': '',
            'testeHistSaudeQ7': '',
            'testeHistSaudeQ8': '',
            'testeHistSaudeQ9': '',
            'testeHistSaudeQ10': '',
            'opcional5': '',
            'opcional6': '',
          },
        ),
      );
      if (aluno.id != null) {
        await _anamneseRepository.createAnamnese(anamnese, aluno.id!);
        NotificacaoEvents.notificarSolicitacaoAnamnese(
          aluno.id!,
          aluno.nome,
        );
      } else {
        throw Exception('Aluno ID is null');
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Aluno>> getAllAlunos() async {
    try {
      final alunos = await _alunoRepository.readAll();
      for (final aluno in alunos) {
        final anamneses = await _anamneseRepository.readByAluno(aluno.id!);
        anamneses.forEach((anamnese) {
          aluno.addAnamnese(anamnese);
        });
      }
      return alunos;
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> visualizarAnamneses() async {
    try {
      final List<Map<String, dynamic>> anamnesesData =
          await _anamneseRepository.getAllAnamneses();
      return anamnesesData;
    } catch (e) {
      throw Exception('Erro ao visualizar anamneses: $e');
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
