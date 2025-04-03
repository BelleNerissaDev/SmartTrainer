import 'package:SmartTrainer/connections/provider/firestore.dart';

import 'package:SmartTrainer/models/entity/anamnese.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnamneseRepository {
  final FirebaseFirestore _firestore;
  late final CollectionReference _anamneseCollection;
  late final CollectionReference _alunoCollection;

  AnamneseRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirestoreProvider.instance {
    _anamneseCollection = _firestore.collection('anamneses');
    _alunoCollection = _firestore.collection('alunos');
  }

  Future<Anamnese> createAnamnese(Anamnese entity, String alunoId) async {
    try {
      final parentDocumentRef = _alunoCollection.doc(alunoId);
      final subCollectionRef = parentDocumentRef.collection('anamneses');

      final document = await subCollectionRef.add(entity.toMap());
      entity.id = document.id;
      return entity;
    } catch (e) {
      throw Exception('Erro ao criar Anamnese ${e}');
    }
  }

  Future<Anamnese> readById(String id) async {
    try {
      final docRef = _anamneseCollection.doc(id);
      final DocumentSnapshot doc = await docRef.get();

      final data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        Anamnese? anamnese = Anamnese.fromMap(data, docRef.id);
        return anamnese;
      } else {
        throw Exception('Anamnese não encontrada');
      }
    } catch (e) {
      throw Exception('Erro ao buscar a Anamnese: $e');
    }
  }

  Future<Anamnese> updateAnamnese(Anamnese entity, String idAluno) async {
    try {
      // Mapeia os dados da anamnese para atualizar
      final data = entity.toMap();

      // Referência ao documento do aluno e à subcoleção "anamneses"
      final docRef =
          _alunoCollection.doc(idAluno).collection('anamneses').doc(entity.id);

      // Atualiza o documento com o ID específico da anamnese
      await docRef.update(data);

      return entity;
    } catch (e) {
      throw Exception('Erro ao atualizar Anamnese: $e');
    }
  }

  Future<Anamnese?> getLastAnamnese(String idAluno) async {
    try {
      final subCollectionRef =
          _alunoCollection.doc(idAluno).collection('anamneses');

      final querySnapshot = await subCollectionRef
          .orderBy('data',
              descending: true) // Ordena pela data (mais recente primeiro)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot doc = querySnapshot.docs.first;
        final data = doc.data()! as Map<String, dynamic>;
        final Anamnese anamnese = Anamnese.fromMap(data, doc.id);
        return anamnese;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Erro ao buscar a anamnese mais recente: $e');
    }
  }
}
