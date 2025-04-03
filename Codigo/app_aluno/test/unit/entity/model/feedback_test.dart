import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/models/entity/feedback.dart';
import 'package:SmartTrainer/models/entity/nivel_esforco.dart';

void main() {
  group('Feedback', () {
    test('should create Feedback object', () {
      final feedback = Feedback(
        nivelEsforco: NivelEsforco.MEDIO,
        observacao: 'Good effort',
      );

      expect(feedback.nivelEsforco, NivelEsforco.MEDIO);
      expect(feedback.observacao, 'Good effort');
    });

    test('should convert Feedback object to map', () {
      final feedback = Feedback(
        nivelEsforco: NivelEsforco.ALTO,
        observacao: 'Great job',
      );

      final feedbackMap = feedback.toMap();

      expect(feedbackMap['nivelEsforco'], NivelEsforco.ALTO.value);
      expect(feedbackMap['observacao'], 'Great job');
    });

    test('should create Feedback object from map', () {
      final feedbackMap = {
        'nivelEsforco': NivelEsforco.BAIXO.value,
        'observacao': 'Needs improvement',
      };

      final feedback = Feedback.fromMap(feedbackMap, '123');

      expect(feedback.nivelEsforco, NivelEsforco.BAIXO);
      expect(feedback.observacao, 'Needs improvement');
      expect(feedback.id, '123');
    });

    test('should update Feedback properties', () {
      final feedback = Feedback(
        nivelEsforco: NivelEsforco.MEDIO,
        observacao: 'Good effort',
      );

      feedback.nivelEsforco = NivelEsforco.MUITO_ALTO;
      feedback.observacao = 'Excellent';

      expect(feedback.nivelEsforco, NivelEsforco.MUITO_ALTO);
      expect(feedback.observacao, 'Excellent');
    });
  });
}
