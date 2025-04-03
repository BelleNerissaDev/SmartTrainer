import 'package:SmartTrainer_Personal/connections/provider/firestore.dart';
import 'package:SmartTrainer_Personal/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer_Personal/connections/repository/plano_treinos_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/feedback.dart';
import 'package:SmartTrainer_Personal/models/entity/plano.dart';
import 'package:SmartTrainer_Personal/models/entity/realizacao_exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/realizacao_treino.dart';
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
      Aluno aluno, DateTime mes) async {
    try {
      final realizacoesTreino = <RealizacaoTreino>[];

      final inicioMes = DateTime(mes.year, mes.month, 1);
      final fimMes = DateTime(mes.year, mes.month + 1, 1)
          .subtract(const Duration(seconds: 1));

      final planos = await PlanoTreinoRepository(firestore: _firestore)
          .readAllByAluno(aluno);

      for (final plano in planos) {
        _planoTreinoCollection =
            _alunoCollection.doc(aluno.id!).collection('plano_treinos');
        _realizacaoTreinoCollection = _planoTreinoCollection
            .doc(plano.id)
            .collection('realizacao_treinos');

        final realizacoesTreinoSnapshot = await _realizacaoTreinoCollection
            .where('data', isGreaterThanOrEqualTo: inicioMes)
            .where('data', isLessThanOrEqualTo: fimMes)
            .orderBy('data', descending: true)
            .get();

        for (final realizacaoTreinoSnapshot in realizacoesTreinoSnapshot.docs) {
          final realizacaoTreinoData =
              realizacaoTreinoSnapshot.data()! as Map<String, dynamic>;

          final realizacaoTreino = await _createRealizacaoTreino(
            realizacaoTreinoData: realizacaoTreinoData,
            realizacaoTreinoSnapshot: realizacaoTreinoSnapshot,
            plano: plano,
          );

          realizacoesTreino.add(realizacaoTreino);
        }
      }

      return realizacoesTreino;
    } catch (e) {
      throw Exception('Erro ao buscar os dados');
    }
  }

  Future<List<DateTime>> readDatasRealizacaoUltimosMeses(Aluno aluno,
      {int meses = 4}) async {
    try {
      final datasRealizacao = <DateTime>[];

      // Calcula a data inicial (4 meses atrás)
      final dataAtual = DateTime.now();
      final dataInicial = DateTime(
        dataAtual.year,
        dataAtual.month - meses,
        dataAtual.day,
      );

      // Busca todos os planos do aluno
      final planos = await PlanoTreinoRepository(firestore: _firestore)
          .readAllByAluno(aluno);

      // Para cada plano, busca as realizações de treino
      for (final plano in planos) {
        _planoTreinoCollection =
            _alunoCollection.doc(aluno.id!).collection('plano_treinos');
        _realizacaoTreinoCollection = _planoTreinoCollection
            .doc(plano.id)
            .collection('realizacao_treinos');

        // Busca as realizações no período especificado
        final realizacoesTreinoSnapshot = await _realizacaoTreinoCollection
            .where('data', isGreaterThanOrEqualTo: dataInicial)
            .where('data', isLessThanOrEqualTo: dataAtual)
            .get();

        // Adiciona as datas ao conjunto de resultados
        for (final doc in realizacoesTreinoSnapshot.docs) {
          final data = (doc.data()! as Map<String, dynamic>)['data'].toDate();
          datasRealizacao.add(data);
        }
      }

      // Ordena as datas em ordem crescente
      datasRealizacao.sort();

      return datasRealizacao;
    } catch (e) {
      throw Exception('Erro ao buscar as datas de realização de treino: $e');
    }
  }
  Future<List<RealizacaoTreino>> findAllUltimaSemana(DateTime hoje) async {
    try {
      final realizacoesTreino = <RealizacaoTreino>[];

      final inicioSemana = hoje.subtract(const Duration(days: 7));
      final fimSemana = hoje;

      final alunoRepository = AlunoRepository(firestore: _firestore);
      final planoRepository = PlanoTreinoRepository(firestore: _firestore);
      final alunos = await alunoRepository.readAll();

      for (final aluno in alunos) {
        final planos = await planoRepository.readAllByAluno(aluno);

        for (final plano in planos) {
          _planoTreinoCollection =
              _alunoCollection.doc(aluno.id!).collection('plano_treinos');
          _realizacaoTreinoCollection = _planoTreinoCollection
              .doc(plano.id)
              .collection('realizacao_treinos');

          final realizacoesTreinoSnapshot = await _realizacaoTreinoCollection
              .where('data', isGreaterThanOrEqualTo: inicioSemana)
              .where('data', isLessThanOrEqualTo: fimSemana)
              .get();

          for (final realizacaoTreinoSnapshot
              in realizacoesTreinoSnapshot.docs) {
            final realizacaoTreinoData =
                realizacaoTreinoSnapshot.data()! as Map<String, dynamic>;

            final realizacaoTreino = await _createRealizacaoTreino(
              realizacaoTreinoData: realizacaoTreinoData,
              realizacaoTreinoSnapshot: realizacaoTreinoSnapshot,
              plano: plano,
            );

            realizacaoTreino.aluno = aluno;

            realizacoesTreino.add(realizacaoTreino);
          }
        }
      }

      realizacoesTreino.sort((a, b) => b.data.compareTo(a.data));

      return realizacoesTreino;
    } catch (e) {
      throw Exception('Erro ao buscar os dados');
    }
  }

  Future<RealizacaoTreino> _createRealizacaoTreino({
    required Map<String, dynamic> realizacaoTreinoData,
    required QueryDocumentSnapshot realizacaoTreinoSnapshot,
    required PlanoTreino plano,
  }) async {
    final realizacaoTreino = RealizacaoTreino.fromMap(
      realizacaoTreinoData,
      realizacaoTreinoSnapshot.id,
      [],
      null,
      plano.treinos.firstWhere(
          (treino) => treino.id == realizacaoTreinoData['treinoId']),
    );

    _realizacaoExercicioCollection =
        realizacaoTreinoSnapshot.reference.collection('realizacao_exercicios');
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

      final feedback = FeedbackTreino.fromMap(
        feedbackData,
        feedbackSnapshot.docs.first.id,
      );

      realizacaoTreino.feedback = feedback;
    }

    return realizacaoTreino;
  }
}
