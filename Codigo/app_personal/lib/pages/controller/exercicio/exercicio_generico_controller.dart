import 'dart:io';

import 'package:SmartTrainer_Personal/connections/repository/exercicio_generico_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ExercicioGenericoController {
  final ExercicioGenericoRepository _exercicioGenericoRepository;
  final FirebaseStorage _storage;

  ExercicioGenericoController({
    ExercicioGenericoRepository? exercicioGenericoRepository,
    FirebaseStorage? storage,
  })  : _exercicioGenericoRepository =
            exercicioGenericoRepository ?? ExercicioGenericoRepository(),
        _storage = storage ?? FirebaseStorage.instance;

  Future<List<Exercicio>> visualizarExercicios() async {
    try {
      final List<Exercicio> exercicios =
          await _exercicioGenericoRepository.readAll();
      return exercicios;
    } catch (e) {
      throw Exception('Erro ao visualizar exercícios: $e');
    }
  }

  Future<bool> adicionarExercicio({
    required String nomeExercicio,
    required String descricao,
    required String metodologia,
    required double carga,
    required String tipoCarga,
    required int repeticoes,
    required int series,
    required String intervalo,
    required String videoUrl,
    required File imagem,
    required List<GrupoMuscular> gruposMusculares,
  }) async {
    try {
      final metodologiaExercicio = MetodologiaExercicio.fromString(metodologia);

      final ref = _storage
          .ref()
          .child('exercicio_generico')
          .child(nomeExercicio.replaceAll(' ', '_'));
      final uploadTask = ref.putFile(imagem);

      final taskSnapshot = await uploadTask;

      final downloadURL = await taskSnapshot.ref.getDownloadURL();
      final exercicio = Exercicio(
        nome: nomeExercicio,
        descricao: descricao,
        metodologia: metodologiaExercicio,
        carga: carga,
        tipoCarga: tipoCarga,
        repeticoes: repeticoes,
        series: series,
        intervalo: intervalo,
        videoUrl: videoUrl,
        imagem: downloadURL,
        gruposMusculares: gruposMusculares,
      );

      await _exercicioGenericoRepository.create(exercicio);

      return true;
    } catch (e) {
      return false;
    }
  }
}
