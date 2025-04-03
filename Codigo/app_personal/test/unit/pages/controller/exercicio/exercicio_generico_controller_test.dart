import 'dart:io';
import 'package:SmartTrainer_Personal/pages/controller/exercicio/exercicio_generico_controller.dart';
import 'package:SmartTrainer_Personal/connections/repository/exercicio_generico_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';

import 'exercicio_generico_controller_test.mocks.dart';

@GenerateMocks([
  ExercicioGenericoRepository,
  FirebaseStorage,
  Reference,
  UploadTask,
  TaskSnapshot
])
void main() {
  group('ExercicioGenericoController', () {
    late ExercicioGenericoController controller;
    late MockExercicioGenericoRepository mockExercicioGenericoRepository;
    late MockFirebaseStorage mockFirebaseStorage;

    setUp(() {
      mockExercicioGenericoRepository = MockExercicioGenericoRepository();
      mockFirebaseStorage = MockFirebaseStorage();
      controller = ExercicioGenericoController(
        exercicioGenericoRepository: mockExercicioGenericoRepository,
        storage: mockFirebaseStorage,
      );
    });

    // TODO teste de ADD exercicio generico
    // ~ erro para add imagem do exercicio no mock

    test(
        'visualizarExercicios should return a list of Exercicio sucessfully',
        () async {
      final exercicios = [
        Exercicio(
          id: '1',
          nome: 'Supino Reto',
          descricao: 'Exercício para peito',
          metodologia: MetodologiaExercicio.TRADICIONAL,
          carga: 50.0,
          repeticoes: 10,
          series: 4,
          intervalo: '1 min',
          gruposMusculares: [GrupoMuscular(id: '1', nome: 'Peito')],
        ),
      ];

      when(mockExercicioGenericoRepository.readAll())
          .thenAnswer((_) async => exercicios);

      final result = await controller.visualizarExercicios();

      expect(result, equals(exercicios));
      verify(mockExercicioGenericoRepository.readAll()).called(1);
    });

    test('visualizarExercicios should throw an exception when an error occurs',
        () async {
      when(mockExercicioGenericoRepository.readAll())
          .thenThrow(Exception('Erro ao visualizar exercícios'));

      expect(controller.visualizarExercicios(), throwsException);
      verify(mockExercicioGenericoRepository.readAll()).called(1);
    });

    test('adicionarExercicio should return false when an error occurs',
        () async {
      const nomeExercicio = 'Supino Reto';
      const descricao = 'Exercício para peito';
      const metodologia = 'Tradicional';
      const carga = 50.0;
      const tipoCarga = 'kg';
      const repeticoes = 10;
      const series = 4;
      const intervalo = '1 min';
      const videoUrl = 'http://video.com/video.mp4';
      final imagem = File('path/to/file');
      final gruposMusculares = [GrupoMuscular(id: '1', nome: 'Peito')];

      when(mockFirebaseStorage.ref()).thenThrow(Exception('Erro no Firebase'));

      final result = await controller.adicionarExercicio(
        nomeExercicio: nomeExercicio,
        descricao: descricao,
        metodologia: metodologia,
        carga: carga,
        tipoCarga: tipoCarga,
        repeticoes: repeticoes,
        series: series,
        intervalo: intervalo,
        videoUrl: videoUrl,
        imagem: imagem,
        gruposMusculares: gruposMusculares,
      );

      expect(result, false);
      verify(mockFirebaseStorage.ref()).called(1);
      verifyNever(mockExercicioGenericoRepository.create(any));
    });
  });
}
