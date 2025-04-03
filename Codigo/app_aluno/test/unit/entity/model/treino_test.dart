import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/models/entity/treino.dart';
import 'package:SmartTrainer/models/entity/exercicio.dart';

void main() {
  group('Treino', () {
    final exercicios = [
      Exercicio(
        nome: 'Push-up',
        metodologia: MetodologiaExercicio.TRADICIONAL,
        descricao: 'Push-up exercise',
        carga: 0,
        repeticoes: 10,
        series: 3,
        intervalo: '01:00',
      ),
      Exercicio(
        nome: 'Squat',
        metodologia: MetodologiaExercicio.TRADICIONAL,
        descricao: 'Squat exercise',
        carga: 0,
        repeticoes: 10,
        series: 3,
        intervalo: '01:00',
      ),
    ];
    test('should create a Treino instance with given values', () {
      final treino =
          Treino(nome: 'Morning Workout', exercicios: exercicios, id: '1');

      expect(treino.nome, 'Morning Workout');
      expect(treino.exercicios, exercicios);
      expect(treino.id, '1');
    });

    test('should convert Treino instance to map', () {
      final treino = Treino(nome: 'Morning Workout');
      final map = treino.toMap();

      expect(map, {'nome': 'Morning Workout'});
    });

    test('should create Treino instance from map', () {
      final map = {'nome': 'Morning Workout'};
      final treino = Treino.fromMap(map, '1', exercicios);

      expect(treino.nome, 'Morning Workout');
      expect(treino.exercicios, exercicios);
      expect(treino.id, '1');
    });

    test('should update the nome property', () {
      final treino = Treino(nome: 'Morning Workout');
      treino.nome = 'Evening Workout';

      expect(treino.nome, 'Evening Workout');
    });
  });
}
