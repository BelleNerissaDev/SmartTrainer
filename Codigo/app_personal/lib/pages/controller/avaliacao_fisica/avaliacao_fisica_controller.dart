import 'dart:io';

import 'package:SmartTrainer_Personal/connections/provider/storage.dart';
import 'package:SmartTrainer_Personal/connections/repository/avaliacao_fisica_repository.dart';
import 'package:SmartTrainer_Personal/events/notificacao_events.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/avaliacao_fisica.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AvaliacaoController {
  final AvaliacaoFisicaRepository _avaliacaoRepository;
  final FirebaseStorage _storage;

  AvaliacaoController({
    AvaliacaoFisicaRepository? avaliacaoRepository,
    FirebaseStorage? storage,
  })  : _avaliacaoRepository =
            avaliacaoRepository ?? AvaliacaoFisicaRepository(),
        _storage = storage ?? StorageProvider.instance;

  Future<bool> solicitarAvaliacaoOnline(Aluno aluno) async {
    try {
      final AvaliacaoFisica avaliacao = AvaliacaoFisica(
        aluno: aluno,
        data: DateTime.now(),
        status: StatusAvaliacao.pendente,
        tipoAvaliacao: TipoAvaliacao.online,
      );
      await _avaliacaoRepository.create(avaliacao);
      NotificacaoEvents.notificarSolicitacaoAvaliacao(
        aluno.id!,
        aluno.nome,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> enviarPdfAvaliacao(Aluno aluno, File avaliacao) async {
    try {
      final avaliacaoFisica = AvaliacaoFisica(
        aluno: aluno,
        data: DateTime.now(),
        status: StatusAvaliacao.realizada,
        tipoAvaliacao: TipoAvaliacao.pdf,
      );
      await _avaliacaoRepository.create(avaliacaoFisica);
      final ref = _storage
          .ref()
          .child('alunos')
          .child(aluno.id!)
          .child('avaliacoes')
          .child(avaliacaoFisica.id!);

      final uploadTask = ref.putFile(avaliacao);

      final taskSnapshot = await uploadTask;

      final downloadURL = await taskSnapshot.ref.getDownloadURL();

      avaliacaoFisica.linkArquivo = downloadURL;

      await _avaliacaoRepository.update(avaliacaoFisica);
      NotificacaoEvents.notificarEnvioAvaliacao(
        aluno.id!,
        aluno.nome,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<AvaliacaoFisica>> getAvaliacoes(Aluno aluno) async {
    try {
      return await _avaliacaoRepository.readByAlunoId(aluno.id!);
    } catch (e) {
      return [];
    }
  }
}
