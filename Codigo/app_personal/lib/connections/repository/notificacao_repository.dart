import 'package:SmartTrainer_Personal/connections/provider/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificacaoRepository {
  final FirebaseFirestore _firestore;
  late final CollectionReference _collection;

  NotificacaoRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirestoreProvider.instance {
    _collection = _firestore.collection('notificacoes');
  }

  Future<bool> create(Map<String, dynamic> entity) async {
    try {
      await _collection.add(entity);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> readAll() async {
    final notificacoes = <Map<String, dynamic>>[];
    final snapshots = await _collection.get();
    for (final doc in snapshots.docs) {
      final data = doc.data()! as Map<String, dynamic>;
      data['dateTime'] = data['dateTime'].toDate();
      data['id'] = doc.id;
      notificacoes.add(data);
    }

    return notificacoes;
  }
}
