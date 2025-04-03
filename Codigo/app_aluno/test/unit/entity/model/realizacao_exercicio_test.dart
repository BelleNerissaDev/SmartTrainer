import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/models/entity/realizacao_exercicio.dart';
import 'package:SmartTrainer/models/entity/nivel_esforco.dart';

void main() {
  group('RealizacaoExercicio', () {
    test('should create an instance with correct values', () {
      final realizacaoExercicio = RealizacaoExercicio(
        novaCarga: 50.0,
        nivelEsforco: NivelEsforco.MEDIO,
        idExercicio: 'ex1',
      );

      expect(realizacaoExercicio.novaCarga, 50.0);
      expect(realizacaoExercicio.nivelEsforco, NivelEsforco.MEDIO);
      expect(realizacaoExercicio.idExercicio, 'ex1');
    });

    test('should convert to map correctly', () {
      final realizacaoExercicio = RealizacaoExercicio(
        novaCarga: 50.0,
        nivelEsforco: NivelEsforco.MEDIO,
        idExercicio: 'ex1',
      );

      final map = realizacaoExercicio.toMap();

      expect(map['novaCarga'], 50.0);
      expect(map['nivelEsforco'], NivelEsforco.MEDIO.value);
      expect(map['idExercicio'], 'ex1');
    });

    test('should create from map correctly', () {
      final map = {
        'novaCarga': 50.0,
        'nivelEsforco': NivelEsforco.MEDIO.value,
        'idExercicio': 'ex1',
      };

      final realizacaoExercicio = RealizacaoExercicio.fromMap(map, 'id1');

      expect(realizacaoExercicio.novaCarga, 50.0);
      expect(realizacaoExercicio.nivelEsforco, NivelEsforco.MEDIO);
      expect(realizacaoExercicio.idExercicio, 'ex1');
      expect(realizacaoExercicio.id, 'id1');
    });

    test('should update properties correctly', () {
      final realizacaoExercicio = RealizacaoExercicio(
        novaCarga: 50.0,
        nivelEsforco: NivelEsforco.MEDIO,
        idExercicio: 'ex1',
      );

      realizacaoExercicio.novaCarga = 60.0;
      realizacaoExercicio.nivelEsforco = NivelEsforco.ALTO;
      realizacaoExercicio.idExercicio = 'ex2';

      expect(realizacaoExercicio.novaCarga, 60.0);
      expect(realizacaoExercicio.nivelEsforco, NivelEsforco.ALTO);
      expect(realizacaoExercicio.idExercicio, 'ex2');
    });
  });
}
