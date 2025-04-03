import 'package:SmartTrainer_Personal/connections/provider/firestore.dart';
import 'package:SmartTrainer_Personal/models/entity/avaliacao_fisica.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvaliacaoFisicaRepository {
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
      if (avaliacao != null) {
        avaliacoes.add(avaliacao);
      }
    }
    return avaliacoes;
  }

  Future<int> countAllPendentes() async {
    try {
      final snapshots = await _alunoCollection.get();
      int count = 0;
      for (final snapshot in snapshots.docs) {
        final avaliacao = await snapshot.reference
            .collection('avaliacoes')
            .where('status', isEqualTo: StatusAvaliacao.pendente.name)
            .limit(1)
            .get();
        if (avaliacao.docs.isNotEmpty) {
          count++;
        }
      }
      return count;
    } catch (e) {
      throw Exception('Erro ao buscar avaliacao: $e');
    }
  }
}
