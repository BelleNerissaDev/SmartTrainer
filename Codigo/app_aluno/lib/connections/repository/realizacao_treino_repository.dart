import 'package:SmartTrainer/connections/provider/firestore.dart';
import 'package:SmartTrainer/connections/repository/plano_treinos_repository.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/feedback.dart';
import 'package:SmartTrainer/models/entity/realizacao_exercicio.dart';
import 'package:SmartTrainer/models/entity/realizacao_treino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RealizacaoTreinoRepository {
  final FirebaseFirestore _firestore;
  late final CollectionReference _alunoCollection;
  late CollectionReference _planoTreinoCollection;
  late CollectionReference _realizacaoTreinoCollection;
  late CollectionReference _realizacaoExercicioCollection;
  late CollectionReference _feedbackCollection;

  RealizacaoTreinoRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirestoreProvider.instance {
    _alunoCollection = _firestore.collection('alunos');
  }

  Future<RealizacaoTreino> create(Aluno aluno, RealizacaoTreino entity) async {
    final planoTreino = await PlanoTreinoRepository(firestore: _firestore)
        .readAtivoByAluno(aluno);

    _planoTreinoCollection =
        _alunoCollection.doc(aluno.id).collection('plano_treinos');
    _realizacaoTreinoCollection = _planoTreinoCollection
        .doc(planoTreino.id)
        .collection('realizacao_treinos');

    final realizacaoTreinoReference =
        await _realizacaoTreinoCollection.add(entity.toMap());

    entity.id = realizacaoTreinoReference.id;

    _realizacaoExercicioCollection =
        realizacaoTreinoReference.collection('realizacao_exercicios');
    _feedbackCollection = realizacaoTreinoReference.collection('feedback');

    for (final realizacaoExercicio in entity.realizacaoExercicios) {
      final reference =
          await _realizacaoExercicioCollection.add(realizacaoExercicio.toMap());
      realizacaoExercicio.id = reference.id;
    }

    final feedback = entity.feedback;

    if (feedback != null) {
      final feedbackReference = await _feedbackCollection.add(feedback.toMap());
      feedback.id = feedbackReference.id;
    }

    return entity;
  }

  Future<List<RealizacaoTreino>> readAllByAlunoByMes(
      Aluno aluno, DateTime hoje) async {
    try {
      final realizacoesTreino = <RealizacaoTreino>[];

      final inicioMes = DateTime(hoje.year, hoje.month, 1);
      final fimMes = DateTime(hoje.year, hoje.month + 1, 1)
          .subtract(const Duration(seconds: 1));

      final plano = await PlanoTreinoRepository(firestore: _firestore)
          .readAtivoByAluno(aluno);

      _planoTreinoCollection =
          _alunoCollection.doc(aluno.id!).collection('plano_treinos');
      _realizacaoTreinoCollection =
          _planoTreinoCollection.doc(plano.id).collection('realizacao_treinos');

      final realizacoesTreinoSnapshot = await _realizacaoTreinoCollection
          .where('data', isGreaterThanOrEqualTo: inicioMes)
          .where('data', isLessThanOrEqualTo: fimMes)
          .get();

      for (final realizacaoTreinoSnapshot in realizacoesTreinoSnapshot.docs) {
        final realizacaoTreinoData =
            realizacaoTreinoSnapshot.data()! as Map<String, dynamic>;

        final realizacaoTreino = RealizacaoTreino.fromMap(
          realizacaoTreinoData,
          realizacaoTreinoSnapshot.id,
          [],
          null,
          plano.treinos.firstWhere(
              (treino) => treino.id == realizacaoTreinoData['treinoId']),
        );

        _realizacaoExercicioCollection = realizacaoTreinoSnapshot.reference
            .collection('realizacao_exercicios');
        _feedbackCollection =
            realizacaoTreinoSnapshot.reference.collection('feedback');

        final realizacaoExerciciosSnapshot =
            await _realizacaoExercicioCollection.get();

        for (final realizacaoExercicioSnapshot
            in realizacaoExerciciosSnapshot.docs) {
          final realizacaoExercicioData =
              realizacaoExercicioSnapshot.data()! as Map<String, dynamic>;

          final realizacaoExercicio = RealizacaoExercicio.fromMap(
            realizacaoExercicioData,
            realizacaoExercicioSnapshot.id,
          );

          realizacaoTreino.realizacaoExercicios.add(realizacaoExercicio);
        }

        final feedbackSnapshot = await _feedbackCollection.get();

        if (feedbackSnapshot.docs.isNotEmpty) {
          final feedbackData =
              feedbackSnapshot.docs.first.data()! as Map<String, dynamic>;

          final feedback = Feedback.fromMap(
            feedbackData,
            feedbackSnapshot.docs.first.id,
          );

          realizacaoTreino.feedback = feedback;
        }

        realizacoesTreino.add(realizacaoTreino);
      }

      return realizacoesTreino;
    } catch (e) {
      throw Exception('Erro ao buscar os dados');
    }
  }

  Future<bool> hasRealizacaoTreinoByAlunoByData(
      Aluno aluno, DateTime data) async {
    try {
      final plano = await PlanoTreinoRepository(firestore: _firestore)
          .readAtivoByAluno(aluno);

      _planoTreinoCollection =
          _alunoCollection.doc(aluno.id!).collection('plano_treinos');
      _realizacaoTreinoCollection =
          _planoTreinoCollection.doc(plano.id).collection('realizacao_treinos');

      final inicioDia = DateTime(data.year, data.month, data.day);
      final fimDia = DateTime(data.year, data.month, data.day, 23, 59, 59);

      final realizacoesTreinoSnapshot = await _realizacaoTreinoCollection
          .where('data', isGreaterThanOrEqualTo: inicioDia)
          .where('data', isLessThanOrEqualTo: fimDia)
          .get();

      if (realizacoesTreinoSnapshot.docs.isNotEmpty) {
        return true;
      }

      return false;
    } catch (e) {
      throw Exception('Erro ao buscar os dados');
    }
  }

  Future<List<DateTime>> findDiasTreinadosUltimosTresMesesByAluno(
      Aluno aluno, DateTime hoje) async {
    try {
      final inicioMes = DateTime(hoje.year, hoje.month - 2, 1);
      final fimMes = DateTime(hoje.year, hoje.month + 1, 1)
          .subtract(const Duration(seconds: 1));

      final plano = await PlanoTreinoRepository(firestore: _firestore)
          .readAtivoByAluno(aluno);

      _planoTreinoCollection =
          _alunoCollection.doc(aluno.id!).collection('plano_treinos');
      _realizacaoTreinoCollection =
          _planoTreinoCollection.doc(plano.id).collection('realizacao_treinos');

      final realizacoesTreinoSnapshot = await _realizacaoTreinoCollection
          .where('data', isGreaterThanOrEqualTo: inicioMes)
          .where('data', isLessThanOrEqualTo: fimMes)
          .get();

      final diasTreinados = <DateTime>[];

      for (final realizacaoTreinoSnapshot in realizacoesTreinoSnapshot.docs) {
        final realizacaoTreinoData =
            realizacaoTreinoSnapshot.data()! as Map<String, dynamic>;

        final data = (realizacaoTreinoData['data'] as Timestamp).toDate();
        final dataSemHora = DateTime(data.year, data.month, data.day);
        diasTreinados.add(dataSemHora);
      }
      return diasTreinados;
    } catch (e) {
      throw Exception('Erro ao buscar os dados');
    }
  }

  Future<int> countByAlunoByMes(Aluno aluno, DateTime hoje) async {
    try {
      final inicioMes = DateTime(hoje.year, hoje.month, 1);
      final fimMes = DateTime(hoje.year, hoje.month + 1, 1)
          .subtract(const Duration(seconds: 1));

      final plano = await PlanoTreinoRepository(firestore: _firestore)
          .readAtivoByAluno(aluno);

      _planoTreinoCollection =
          _alunoCollection.doc(aluno.id!).collection('plano_treinos');
      _realizacaoTreinoCollection =
          _planoTreinoCollection.doc(plano.id).collection('realizacao_treinos');

      final realizacoesTreinoSnapshot = await _realizacaoTreinoCollection
          .where('data', isGreaterThanOrEqualTo: inicioMes)
          .where('data', isLessThanOrEqualTo: fimMes)
          .get();

      return realizacoesTreinoSnapshot.docs.length;
    } catch (e) {
      throw Exception('Erro ao buscar os dados');
    }
  }
}
