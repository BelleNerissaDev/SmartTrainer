import 'package:SmartTrainer_Personal/connections/repository/exercicio_generico_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ExercicioGenericoRepository', () {
    late FakeFirebaseFirestore instance;
    late ExercicioGenericoRepository exercicioRepository;

    setUp(() async {
      instance = FakeFirebaseFirestore();
      exercicioRepository = ExercicioGenericoRepository(firestore: instance);
    });

    test('create should add a new exercicio to the collection', () async {
      final exercicio = Exercicio(
        id: null,
        nome: 'Supino',
        descricao: 'Exercicio de peito',
        carga: 20.0,
        intervalo: '1:00',
        repeticoes: 10,
        series: 3,
        gruposMusculares: [GrupoMuscular(id: '1', nome: 'Peito')],
        metodologia: MetodologiaExercicio.TRADICIONAL,
      );

      final createdExercicio = await exercicioRepository.create(exercicio);

      final snapshot = await instance
          .collection('exercicio_generico')
          .doc(createdExercicio.id)
          .get();
      expect(snapshot.exists, isTrue);
      expect(snapshot['nome'], equals('Supino'));
    });

    test('readAll should return a list of all exercicios', () async {
      await instance.collection('exercicio_generico').add({
        'nome': 'Supino',
        'descricao': 'Exercicio de peito',
        'carga': 20.0,
        'intervalo': '1:00',
        'repeticoes': 10,
        'series': 3,
        'gruposMusculares': ['1'],
        'metodologia': 'TRADICIONAL'
      });

      final exercicios = await exercicioRepository.readAll();

      expect(exercicios, isNotEmpty);
      expect(exercicios.first.nome, equals('Supino'));
    });

    test('update should modify an existing exercicio in the collection',
        () async {
      final docRef = await instance.collection('exercicio_generico').add({
        'nome': 'Supino',
        'descricao': 'Exercicio de peito',
        'carga': 20.0,
        'intervalo': '1:00',
        'repeticoes': 10,
        'series': 3,
        'gruposMusculares': ['1'],
        'metodologia': 'TRADICIONAL'
      });

      final updatedExercicio = Exercicio(
        id: docRef.id,
        nome: 'Supino Atualizado',
        descricao: 'Exercicio de peito atualizado',
        carga: 25.0,
        intervalo: '1:15',
        repeticoes: 8,
        series: 4,
        gruposMusculares: [GrupoMuscular(id: '1', nome: 'Peito')],
        metodologia: MetodologiaExercicio.TRADICIONAL,
      );

      await exercicioRepository.update(updatedExercicio);

      final snapshot =
          await instance.collection('exercicio_generico').doc(docRef.id).get();
      expect(snapshot['nome'], equals('Supino Atualizado'));
      expect(snapshot['carga'], equals(25.0));
    });

    test('readByGrupoMuscular should return exercicios matching grupoMuscular',
        () async {
      await instance.collection('exercicio_generico').add({
        'nome': 'Supino',
        'descricao': 'Exercicio de peito',
        'carga': 20.0,
        'intervalo': '1:00',
        'repeticoes': 10,
        'series': 3,
        'gruposMusculares': ['1'],
        'metodologia': 'TRADICIONAL'
      });

      final exercicios = await exercicioRepository.readByGrupoMuscular(['1']);

      expect(exercicios, isNotEmpty);
      expect(exercicios.first.nome, equals('Supino'));
    });

    test(
        // ignore: lines_longer_than_80_chars
        'updateGrupoMuscularInExercicio should add or remove grupoMuscular in exercicio',
        () async {
      final docRef = await instance.collection('exercicio_generico').add({
        'nome': 'Supino',
        'descricao': 'Exercicio de peito',
        'carga': 20.0,
        'intervalo': '1:00',
        'repeticoes': 10,
        'series': 3,
        'gruposMusculares': [],
        'metodologia': 'TRADICIONAL'
      });

      // Teste para adicionar grupo muscular
      await exercicioRepository.updateGrupoMuscularInExercicio('1', docRef.id,
          isAdding: true);
      var snapshot =
          await instance.collection('exercicio_generico').doc(docRef.id).get();
      expect(snapshot['gruposMusculares'], contains('1'));

      // Teste para remover grupo muscular
      await exercicioRepository.updateGrupoMuscularInExercicio('1', docRef.id,
          isAdding: false);
      snapshot =
          await instance.collection('exercicio_generico').doc(docRef.id).get();
      expect(snapshot['gruposMusculares'], isNot(contains('1')));
    });
  });
}
