import 'package:SmartTrainer/connections/provider/firestore.dart';

import 'package:SmartTrainer/models/entity/avaliacao_fisica.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvaliacaoFisicaRepository{
  final FirebaseFirestore _firestore;
  late final CollectionReference _alunoCollection;
  late CollectionReference _avaliacaoCollection;

  AvaliacaoFisicaRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirestoreProvider.instance {
    _alunoCollection = _firestore.collection('alunos');
  }

  Future<AvaliacaoFisica> create(AvaliacaoFisica entity) async {
    if (entity.aluno == null) {
      throw Exception('Aluno não informado');
    }
    _avaliacaoCollection =
        _alunoCollection.doc(entity.aluno!.id).collection('avaliacoes');
    final avaliacaoReference = await _avaliacaoCollection.add(entity.toMap());
    entity.id = avaliacaoReference.id;
    return entity;
  }

  Future<AvaliacaoFisica> update(AvaliacaoFisica entity) async {
    try {
      final data = entity.toMap();
      _avaliacaoCollection =
          _alunoCollection.doc(entity.aluno!.id).collection('avaliacoes');
      final docRef = _avaliacaoCollection.doc(entity.id);
      await docRef.update(data);
      return entity;
    } catch (e) {
      throw Exception('Erro ao atualizar avaliação');
    }
  }

  Future<List<AvaliacaoFisica>> readByAlunoId(String alunoId) async {
    final avaliacoes = <AvaliacaoFisica>[];
    final snapshot =
        await _alunoCollection.doc(alunoId).collection('avaliacoes').get();
    for (final doc in snapshot.docs) {
      final avaliacao = AvaliacaoFisica.fromMap(doc.data());
      avaliacao?.id = doc.id;
      if (avaliacao != null) {
        avaliacoes.add(avaliacao);
      }
    }
    return avaliacoes;
  }
}
