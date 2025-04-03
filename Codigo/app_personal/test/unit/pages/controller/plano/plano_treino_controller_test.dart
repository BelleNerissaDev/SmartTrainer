import 'package:SmartTrainer_Personal/connections/repository/plano_treinos_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/plano.dart';
import 'package:SmartTrainer_Personal/models/entity/treino.dart';
import 'package:SmartTrainer_Personal/pages/controller/plano_treino/plano_treino_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'plano_treino_controller_test.mocks.dart';

@GenerateMocks([PlanoTreinoRepository])
void main() {
  group('PlanoTreinoController', () {
    late PlanoTreinoController controller;
    late MockPlanoTreinoRepository mockPlanoTreinoRepository;

    setUp(() {
      mockPlanoTreinoRepository = MockPlanoTreinoRepository();
      controller = PlanoTreinoController(
          planoTreinoRepository: mockPlanoTreinoRepository);
    });

    test('criarPlanoTreino should complete without throwing an error',
        () async {
      const alunoId = 'aluno1';
      final plano =
          PlanoTreino(nome: 'Plano A', treinos: <Treino>[], status: 'Inativo');

      when(mockPlanoTreinoRepository.createPlanoTreinos(
        alunoId: alunoId,
        plano: plano,
      )).thenAnswer((_) async => {});

      await controller.criarPlanoTreino(alunoId: alunoId, plano: plano);

      verify(mockPlanoTreinoRepository.createPlanoTreinos(
              alunoId: alunoId, plano: plano))
          .called(1);
    });

    test('editarPlanoTreino should complete without throwing an error',
        () async {
      const alunoId = 'aluno1';
      const planoId = 'plano1';
      final plano = PlanoTreino(
          nome: 'Plano Editado', treinos: <Treino>[], status: 'Inativo');

      when(mockPlanoTreinoRepository.editPlanoTreinos(
        alunoId: alunoId,
        planoId: planoId,
        plano: plano,
      )).thenAnswer((_) async => {});

      await controller.editarPlanoTreino(
          alunoId: alunoId, planoId: planoId, plano: plano);

      verify(mockPlanoTreinoRepository.editPlanoTreinos(
              alunoId: alunoId, planoId: planoId, plano: plano))
          .called(1);
    });

    test('deletarPlanoTreino should complete without throwing an error',
        () async {
      const alunoId = 'aluno1';
      const planoId = 'plano1';

      when(mockPlanoTreinoRepository.deletePlanoTreino(
              planoId: planoId, alunoId: alunoId))
          .thenAnswer((_) async => {});

      await controller.deletarPlanoTreino(alunoId: alunoId, planoId: planoId);

      verify(mockPlanoTreinoRepository.deletePlanoTreino(
              planoId: planoId, alunoId: alunoId))
          .called(1);
    });

    test('ativarPlanoTreino should complete without throwing an error',
        () async {
      const alunoId = 'aluno1';
      const planoId = 'plano1';

      when(mockPlanoTreinoRepository.activatePlanoTreino(
              planoId: planoId, alunoId: alunoId))
          .thenAnswer((_) async => {});

      await controller.ativarPlanoTreino(alunoId: alunoId, planoId: planoId);

      verify(mockPlanoTreinoRepository.activatePlanoTreino(
              planoId: planoId, alunoId: alunoId))
          .called(1);
    });

    test('fetchPlanoTreinoAtivo should return a list of planos treino',
        () async {
      const alunoId = 'aluno1';
      final planosTreino = [
        PlanoTreino(nome: 'Plano Ativo', treinos: <Treino>[], status: 'Inativo')
      ];

      when(mockPlanoTreinoRepository.getPlanoTreinoFromAluno(alunoId))
          .thenAnswer((_) async => planosTreino);

      final result = await controller.fetchPlanoTreinoAtivo(alunoId);

      expect(result, isNotEmpty);
      expect(result[0].nome, 'Plano Ativo');
      verify(mockPlanoTreinoRepository.getPlanoTreinoFromAluno(alunoId))
          .called(1);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'fetchTodosPlanosTreinoAluno should return a list of all planos treino for an aluno',
        () async {
      const alunoId = 'aluno1';
      final planosTreino = [
        PlanoTreino(
            nome: 'Plano Completo', treinos: <Treino>[], status: 'Inativo')
      ];

      when(mockPlanoTreinoRepository.getAllPlanosTreinoFromAluno(alunoId))
          .thenAnswer((_) async => planosTreino);

      final result = await controller.fetchTodosPlanosTreinoAluno(alunoId);

      expect(result, isNotEmpty);
      expect(result[0].nome, 'Plano Completo');
      verify(mockPlanoTreinoRepository.getAllPlanosTreinoFromAluno(alunoId))
          .called(1);
    });
  });
}
