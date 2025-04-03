import 'package:SmartTrainer/connections/provider/firestore.dart';
import 'package:SmartTrainer/connections/repository/pacote_repository.dart';

import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlunoRepository{
  final FirebaseFirestore _firestore;
  late final CollectionReference _collection;

  AlunoRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirestoreProvider.instance {
    _collection = _firestore.collection('alunos');
  }

  Future<Aluno> readById(String id) async {
    try {
      final docRef = _collection.doc(id);
      final DocumentSnapshot doc = await docRef.get();

      final data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        final pacoteRepository = PacoteRepository(firestore: _firestore);
        final pacote = await pacoteRepository.readById(data['pacoteId']);
        Aluno? aluno = Aluno.fromMap(data, doc.id, pacote);
        return aluno!;
      } else {
        throw Exception('Aluno não encontrado');
      }
    } catch (e) {
      throw Exception('Erro ao buscar o aluno: $e');
    }
  }

  Future<Aluno> update(Aluno entity) async {
    try {
      final data = entity.toMap();
      final docRef = _collection.doc(entity.id);
      await docRef.update(data);
      return entity;
    } catch (e) {
      throw Exception('Erro ao atualizar aluno');
    }
  }

  Future<Aluno> readBy(String key, value) async {
    try {
      final docRef = await _collection
          .where(key, isEqualTo: value)
          .limit(1)
          .get()
          .then((value) => value.docs.first);

      final data = docRef.data() as Map<String, dynamic>?;

      if (data != null) {
        final pacoteRepository = PacoteRepository(firestore: _firestore);
        final pacote = await pacoteRepository.readById(data['pacoteId']);
        Aluno? aluno = Aluno.fromMap(data, docRef.id, pacote);
        return aluno!;
      } else {
        throw Exception('Aluno não encontrado');
      }
    } catch (e) {
      throw Exception('Aluno não encontrado');
    }
  }
}
