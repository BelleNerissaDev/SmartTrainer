import 'package:SmartTrainer_Personal/connections/provider/firestore.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GrupoMuscularRepository {
  final FirebaseFirestore _firestore;
  late final CollectionReference _collection;

  GrupoMuscularRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirestoreProvider.instance {
    _collection = _firestore.collection('gruposMusculares');
  }

  Future<List<GrupoMuscular>> readAll() async {
    final grupos = <GrupoMuscular>[];
    final snapshots = await _collection.get();
    for (final doc in snapshots.docs) {
      final data = doc.data()! as Map<String, dynamic>;
      GrupoMuscular? grupo = GrupoMuscular.fromMap(data, doc.id);
      grupos.add(grupo);
    }
    return grupos;
  }

  Future<GrupoMuscular> readById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      final data = doc.data()! as Map<String, dynamic>;
      GrupoMuscular grupo = GrupoMuscular.fromMap(data, doc.id);
      return grupo;
    } catch (e) {
      throw Exception('Erro ao buscar grupo muscular: $e');
    }
  }
}
