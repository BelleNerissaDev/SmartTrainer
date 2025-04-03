// ignore_for_file: lines_longer_than_80_chars

import 'package:SmartTrainer_Personal/pages/controller/grupo_muscular/grupo_muscular_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:SmartTrainer_Personal/connections/repository/grupo_muscular_repository.dart';
import 'package:SmartTrainer_Personal/connections/repository/exercicio_generico_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';

import 'grupo_muscular_controller_test.mocks.dart';

@GenerateMocks([GrupoMuscularRepository, ExercicioGenericoRepository])
void main() {
  group('GrupoMuscularController', () {
    late GrupoMuscularController controller;
    late MockGrupoMuscularRepository mockGrupoMuscularRepository;
    late MockExercicioGenericoRepository mockExercicioGenericoRepository;

    setUp(() {
      mockGrupoMuscularRepository = MockGrupoMuscularRepository();
      mockExercicioGenericoRepository = MockExercicioGenericoRepository();
      controller = GrupoMuscularController(
        grupoMuscularRepository: mockGrupoMuscularRepository,
        exercicioGenericoRepository: mockExercicioGenericoRepository,
      );
    });

    test(
        'visualizarGruposMusculares should return a list of GrupoMuscular when successful',
        () async {
      final gruposMusculares = [
        GrupoMuscular(id: '1', nome: 'Peito'),
        GrupoMuscular(id: '2', nome: 'Costas'),
      ];

      when(mockGrupoMuscularRepository.readAll())
          .thenAnswer((_) async => gruposMusculares);

      final result = await controller.visualizarGruposMusculares();

      expect(result, equals(gruposMusculares));
      verify(mockGrupoMuscularRepository.readAll()).called(1);
    });

    test(
        'visualizarGruposMusculares should throw an exception when an error occurs',
        () async {
      when(mockGrupoMuscularRepository.readAll())
          .thenThrow(Exception('Erro ao carregar grupos musculares'));

      expect(controller.visualizarGruposMusculares(), throwsException);
      verify(mockGrupoMuscularRepository.readAll()).called(1);
    });

    test(
        'visualizarExerciciosPorGrupoMuscular should return a list of Exercicio when successful',
        () async {
      final gruposIds = ['1'];
      final exercicios = [
        Exercicio(
          id: '101',
          nome: 'Supino Reto',
          metodologia: MetodologiaExercicio.TRADICIONAL,
          descricao: 'Exercício de peito',
          carga: 50,
          repeticoes: 10,
          series: 4,
          intervalo: '1 min',
          gruposMusculares: [GrupoMuscular(id: '1', nome: 'Peito')],
        )
      ];

      when(mockExercicioGenericoRepository.readByGrupoMuscular(gruposIds))
          .thenAnswer((_) async => exercicios);

      final result =
          await controller.visualizarExerciciosPorGrupoMuscular(gruposIds);

      expect(result, equals(exercicios));
      verify(mockExercicioGenericoRepository.readByGrupoMuscular(gruposIds))
          .called(1);
    });

    test(
        'visualizarExerciciosPorGrupoMuscular should throw an exception when an error occurs',
        () async {
      final gruposIds = ['1'];

      when(mockExercicioGenericoRepository.readByGrupoMuscular(gruposIds))
          .thenThrow(Exception('Erro ao carregar exercícios'));

      expect(controller.visualizarExerciciosPorGrupoMuscular(gruposIds),
          throwsException);
      verify(mockExercicioGenericoRepository.readByGrupoMuscular(gruposIds))
          .called(1);
    });

    test(
        'atualizarGrupoMuscularEmExercicio should call updateGrupoMuscularInExercicio with isAdding true',
        () async {
      const grupoMuscularId = '1';
      const exercicioId = '101';
      const isAdding = true;

      when(mockExercicioGenericoRepository.updateGrupoMuscularInExercicio(
              grupoMuscularId, exercicioId,
              isAdding: isAdding))
          .thenAnswer((_) async => null);

      await controller.atualizarGrupoMuscularEmExercicio(
          grupoMuscularId, exercicioId,
          isAdding: isAdding);

      verify(mockExercicioGenericoRepository.updateGrupoMuscularInExercicio(
              grupoMuscularId, exercicioId,
              isAdding: isAdding))
          .called(1);
    });

    test(
        'atualizarGrupoMuscularEmExercicio should throw an exception when an error occurs',
        () async {
      const grupoMuscularId = '1';
      const exercicioId = '101';
      const isAdding = false;

      when(mockExercicioGenericoRepository.updateGrupoMuscularInExercicio(
              grupoMuscularId, exercicioId,
              isAdding: isAdding))
          .thenThrow(Exception('Erro ao atualizar grupo muscular'));

      expect(
          controller.atualizarGrupoMuscularEmExercicio(
              grupoMuscularId, exercicioId,
              isAdding: isAdding),
          throwsException);
      verify(mockExercicioGenericoRepository.updateGrupoMuscularInExercicio(
              grupoMuscularId, exercicioId,
              isAdding: isAdding))
          .called(1);
    });
  });
}
