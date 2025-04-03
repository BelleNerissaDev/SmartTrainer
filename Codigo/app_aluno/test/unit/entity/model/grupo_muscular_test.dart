import 'package:SmartTrainer/models/entity/grupo_muscular.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GrupoMuscular', () {
    test('should create an instance from a map', () {
      final map = {'nome': 'Peito'};
      final grupoMuscular = GrupoMuscular.fromMap(map, '1');

      expect(grupoMuscular.nome, 'Peito');
      expect(grupoMuscular.id, '1');
    });

    test('should convert an instance to a map', () {
      final grupoMuscular = GrupoMuscular(nome: 'Peito', id: '1');
      final map = grupoMuscular.toMap();

      expect(map, {'nome': 'Peito', 'id': '1'});
    });

    test('should return true for equal objects', () {
      final grupoMuscular1 = GrupoMuscular(nome: 'Peito', id: '1');
      final grupoMuscular2 = GrupoMuscular(nome: 'Peito', id: '1');

      expect(grupoMuscular1, grupoMuscular2);
    });

    test('should return false for different objects', () {
      final grupoMuscular1 = GrupoMuscular(nome: 'Peito', id: '1');
      final grupoMuscular2 = GrupoMuscular(nome: 'Costas', id: '2');

      expect(grupoMuscular1, isNot(grupoMuscular2));
    });

    test('should have correct hash code', () {
      final grupoMuscular = GrupoMuscular(nome: 'Peito', id: '1');

      expect(grupoMuscular.hashCode, '1'.hashCode);
    });
  });
}
