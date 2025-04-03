import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StatusAlunoEnum', () {
    test('toString should return "Ativo" for ATIVO', () {
      expect(StatusAlunoEnum.ATIVO.toString(), 'Ativo');
    });

    test('toString should return "Bloqueado" for BLOQUEADO', () {
      expect(StatusAlunoEnum.BLOQUEADO.toString(), 'Bloqueado');
    });
  });
}
