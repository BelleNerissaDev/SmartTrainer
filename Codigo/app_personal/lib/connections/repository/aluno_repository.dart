import 'package:SmartTrainer_Personal/connections/provider/firestore.dart';
import 'package:SmartTrainer_Personal/connections/repository/pacote_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlunoRepository {
  final FirebaseFirestore _firestore;
  late final CollectionReference _collection;

  AlunoRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirestoreProvider.instance {
    _collection = _firestore.collection('alunos');
  }

  Future<Aluno> create(Aluno entity) async {
    final document = await _collection.add(entity.toMap());

    entity.id = document.id;

    return entity;
  }

  Future<void> delete(String id) async {
    try {
      final docRef = _collection.doc(id);

      final subcollections = ['anamneses', 'avaliacoes', 'plano_treinos'];

      for (String subcollection in subcollections) {
        final querySnapshot = await docRef.collection(subcollection).get();

        final batch = _firestore.batch();
        for (var doc in querySnapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      }

      await docRef.delete();
    } catch (e) {
      throw Exception('Erro ao excluir aluno: $e');
    }
  }

  Future<List<Aluno>> readAll() async {
    final alunos = <Aluno>[];
    final snapshots = await _collection.get();
    for (final doc in snapshots.docs) {
      final data = doc.data()! as Map<String, dynamic>;

      final pacoteRepository = PacoteRepository(firestore: _firestore);
      final pacote = await pacoteRepository.readById(data['pacoteId']);
      Aluno? aluno = Aluno.fromMap(data, doc.id, pacote);
      alunos.add(aluno!);
    }

    return alunos;
  }

  Future<List<Aluno>> readAllWithPlanos() async {
    final alunos = <Aluno>[];
    final snapshots = await _collection.get(); // Obtém todos os alunos

    for (final doc in snapshots.docs) {
      // Verifica se a subcoleção plano_treinos existe
      final planoTreinosSnapshot =
          await doc.reference.collection('plano_treinos').get();

      if (planoTreinosSnapshot.docs.isNotEmpty) {
        // Extrai os dados do aluno
        final data = doc.data()! as Map<String, dynamic>;

        // Obtém o pacote associado (se aplicável)
        final pacoteRepository = PacoteRepository(firestore: _firestore);
        final pacote = await pacoteRepository.readById(data['pacoteId']);

        // Cria o objeto Aluno e adiciona à lista
        Aluno? aluno = Aluno.fromMap(data, doc.id, pacote);
        alunos.add(aluno!);
      }
    }
    return alunos;
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
      final pacoteRepository = PacoteRepository(firestore: _firestore);
      final pacote = await pacoteRepository.readById(data!['pacoteId']);

      Aluno? aluno = Aluno.fromMap(data, docRef.id, pacote);
      aluno!.id = docRef.id;

      return aluno;
    } catch (e) {
      throw Exception('Aluno não encontrado');
    }
  }

  Future<int> countAll() async {
    final snapshots = await _collection.get();
    return snapshots.size;
  }
}
