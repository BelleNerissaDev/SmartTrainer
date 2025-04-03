import 'package:SmartTrainer_Personal/connections/provider/firestore.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacoteRepository {
  final FirebaseFirestore _firestore;
  late final CollectionReference _collection;

  PacoteRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirestoreProvider.instance {
    _collection = _firestore.collection('pacotes');
  }

  Future<Pacote> create(Pacote entity) async {
    final document = await _collection.add(entity.toMap());
    entity.id = document.id;
    return entity;
  }

  Future<List<Pacote>> readAll() async {
    // Método para listar todos os alunos
    try {
      final QuerySnapshot querySnapshot = await _collection.get();

      // Verifica se há documentos na coleção
      if (querySnapshot.docs.isNotEmpty) {
        // Converte cada documento em um objeto Pacote
        return querySnapshot.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>?;
              if (data != null) {
                final pacote = Pacote.fromMap(data, doc.id);
                return pacote;
              } else {
                return null;
              }
            })
            .where((pacote) => pacote != null)
            .cast<Pacote>()
            .toList();
      } else {
        throw Exception('Nenhum pacote encontrado');
      }
    } catch (e) {
      throw Exception('Erro ao buscar pacotes: $e');
    }
  }

  Future<Pacote> readById(String id) async {
    try {
      final docRef = _collection.doc(id);
      final DocumentSnapshot doc = await docRef.get();

      final data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        Pacote? pacote = Pacote.fromMap(data, docRef.id);
        pacote!.id = docRef.id;
        return pacote;
      } else {
        throw Exception('Pacote não encontrado');
      }
    } catch (e) {
      throw Exception('Erro ao buscar o pacote: $e');
    }
  }

  Future<Pacote> update(Pacote entity) async {
    try {
      final data = entity.toMap();
      final docRef = _collection.doc(entity.id);
      await docRef.update(data);
      return entity;
    } catch (e) {
      throw Exception('Erro ao atualizar pacote: $e');
    }
  }
}
