// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';

void main() {
  group('GrupoMuscular', () {
    test(
        'toMap should return a valid map representation of the GrupoMuscular object',
        () {
      final grupoMuscular = GrupoMuscular(
        nome: 'Peito',
        id: '1',
      );

      final map = grupoMuscular.toMap();

      expect(map['nome'], equals('Peito'));
      expect(map['id'], equals('1'));
    });

    test(
        'fromMap should return a valid GrupoMuscular object from a map representation',
        () {
      final map = {
        'nome': 'Costas',
      };

      final grupoMuscular = GrupoMuscular.fromMap(map, '2');

      expect(grupoMuscular.nome, equals('Costas'));
      expect(grupoMuscular.id, equals('2'));
    });

    test('fromMap should throw an exception when id is not provided', () {
      final map = {
        'nome': 'Pernas',
      };

      expect(() => GrupoMuscular.fromMap(map), throwsA(isA<TypeError>()));
    });

    test('should create a valid GrupoMuscular object and test the getters', () {
      final grupoMuscular = GrupoMuscular(
        nome: 'Bíceps',
        id: '3',
      );

      expect(grupoMuscular.nome, equals('Bíceps'));
      expect(grupoMuscular.id, equals('3'));
    });

    test('grupoMuscularFormatName should correctly format the name', () {
      const rawName = 'Costas_superiores';
      const formattedName = 'costas_superiores';

      expect(grupoMuscularFormatName(rawName), equals(formattedName));
    });
  });
}
