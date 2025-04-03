import 'package:SmartTrainer_Personal/connections/repository/grupo_muscular_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('GrupoMuscularRepository', () {
    late FakeFirebaseFirestore instance;
    late GrupoMuscularRepository grupoMuscularRepository;

    setUp(() async {
      instance = FakeFirebaseFirestore();
      grupoMuscularRepository = GrupoMuscularRepository(firestore: instance);
    });

    test('readAll should return a list of all grupos musculares', () async {
      // Adiciona um grupo muscular ao Firestore falso
      await instance.collection('gruposMusculares').add({
        'nome': 'Peitoral',
      });
      await instance.collection('gruposMusculares').add({
        'nome': 'Bíceps',
      });

      // Lê todos os grupos musculares
      final grupos = await grupoMuscularRepository.readAll();

      // Verifica se os grupos foram carregados corretamente
      expect(grupos.length, equals(2));
      expect(grupos[0].nome, equals('Peitoral'));
      expect(grupos[1].nome, equals('Bíceps'));
    });
  });
}
