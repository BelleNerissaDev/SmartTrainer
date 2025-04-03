import 'package:SmartTrainer_Personal/connections/provider/firestore.dart';
import 'package:SmartTrainer_Personal/connections/repository/grupo_muscular_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExercicioGenericoRepository{
  final FirebaseFirestore _firestore;
  late final CollectionReference _collection;

  ExercicioGenericoRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirestoreProvider.instance {
    _collection = _firestore.collection('exercicio_generico');
  }

  Future<Exercicio> create(Exercicio entity) async {
    final document = await _collection.add(entity.toMap());
    entity.id = document.id;
    return entity;
  }

  Future<List<Exercicio>> readAll() async {
    final exercicios = <Exercicio>[];
    final snapshots = await _collection.get();
    for (final doc in snapshots.docs) {
      final data = doc.data()! as Map<String, dynamic>;
      final grupoMuscularRepository =
          GrupoMuscularRepository(firestore: _firestore);
      final gruposMusculares = await grupoMuscularRepository.readAll();
      final filteredGruposMusculares = gruposMusculares
          .where((grupo) => data['gruposMusculares'].contains(grupo.id))
          .toList();
      data['gruposMusculares'] = filteredGruposMusculares;
      Exercicio? exercicio = Exercicio.fromMap(data, doc.id);
      exercicios.add(exercicio);
    }
    return exercicios;
  }

  Future<Exercicio> update(Exercicio entity) async {
    final docRef = _collection.doc(entity.id);
    await docRef.update(entity.toMap());
    return entity;
  }

  Future<List<Exercicio>> readByGrupoMuscular(
      List<String> gruposMusculares) async {
    final exercicios = <Exercicio>[];
    final snapshots = await _collection
        .where('gruposMusculares', arrayContainsAny: gruposMusculares)
        .get();
    for (final doc in snapshots.docs) {
      final data = doc.data()! as Map<String, dynamic>;
      final grupoMuscularRepository =
          GrupoMuscularRepository(firestore: _firestore);
      final gruposMusculares = await grupoMuscularRepository.readAll();
      final filteredGruposMusculares = gruposMusculares
          .where((grupo) => data['gruposMusculares'].contains(grupo.id))
          .toList();
      data['gruposMusculares'] = filteredGruposMusculares;

      Exercicio? exercicio = Exercicio.fromMap(data, doc.id);
      exercicios.add(exercicio);
    }
    return exercicios;
  }

  Future<void> updateGrupoMuscularInExercicio(
      String grupoMuscularId, String exercicioId,
      {required bool isAdding}) async {
    final docRef = _collection.doc(exercicioId);
    if (isAdding) {
      await docRef.update({
        'gruposMusculares': FieldValue.arrayUnion([grupoMuscularId])
      });
    } else {
      await docRef.update({
        'gruposMusculares': FieldValue.arrayRemove([grupoMuscularId])
      });
    }
  }
}
