import 'package:SmartTrainer/models/entity/nivel_esforco.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/models/entity/realizacao_treino.dart';
import 'package:SmartTrainer/models/entity/treino.dart';
import 'package:SmartTrainer/models/entity/realizacao_exercicio.dart';
import 'package:SmartTrainer/models/entity/feedback.dart' as entity;
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('RealizacaoTreino', () {
    final treino = Treino(id: 'treino1', nome: 'Treino A');
    final realizacaoExercicio = RealizacaoExercicio(
      id: 'exercicio1',
      novaCarga: 50,
      nivelEsforco: NivelEsforco.ALTO,
      idExercicio: '6',
    );
    final feedback = entity.Feedback(
        id: 'feedback1',
        observacao: 'Bom treino',
        nivelEsforco: NivelEsforco.MEDIO);
    final realizacaoTreino = RealizacaoTreino(
      data: DateTime(2023, 10, 1),
      treino: treino,
      tempo: 60,
      realizacaoExercicios: [realizacaoExercicio],
      feedback: feedback,
    );

    test('should create an instance of RealizacaoTreino', () {
      expect(realizacaoTreino.data, DateTime(2023, 10, 1));
      expect(realizacaoTreino.treino, treino);
      expect(realizacaoTreino.tempo, 60);
      expect(realizacaoTreino.realizacaoExercicios, [realizacaoExercicio]);
      expect(realizacaoTreino.feedback, feedback);
    });

    test('should convert RealizacaoTreino to map', () {
      final map = realizacaoTreino.toMap();
      expect(map['data'], DateTime(2023, 10, 1));
      expect(map['treinoId'], 'treino1');
      expect(map['tempo'], 60);
    });

    test('should create RealizacaoTreino from map', () {
      final map = {
        'data': Timestamp.fromDate(DateTime(2023, 10, 1)),
        'tempo': 60,
      };
      final realizacaoTreinoFromMap = RealizacaoTreino.fromMap(
        map,
        'realizacao1',
        [realizacaoExercicio],
        feedback,
        treino,
      );
      expect(realizacaoTreinoFromMap.data, DateTime(2023, 10, 1));
      expect(realizacaoTreinoFromMap.treino, treino);
      expect(realizacaoTreinoFromMap.tempo, 60);
      expect(
          realizacaoTreinoFromMap.realizacaoExercicios, [realizacaoExercicio]);
      expect(realizacaoTreinoFromMap.feedback, feedback);
    });
  });
}
