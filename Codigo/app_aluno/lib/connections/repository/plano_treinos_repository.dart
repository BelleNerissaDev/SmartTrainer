import 'package:SmartTrainer/connections/provider/firestore.dart';
import 'package:SmartTrainer/connections/repository/grupo_muscular_repository.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';

import 'package:SmartTrainer/models/entity/exercicio.dart';
import 'package:SmartTrainer/models/entity/grupo_muscular.dart';
import 'package:SmartTrainer/models/entity/plano_treino.dart';
import 'package:SmartTrainer/models/entity/treino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlanoTreinoRepository {
  final FirebaseFirestore _firestore;
  late final CollectionReference _alunoCollection;

  PlanoTreinoRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirestoreProvider.instance {
    _alunoCollection = _firestore.collection('alunos');
  }

  Future<void> createPlanoTreinos({
    required String alunoId,
    required PlanoTreino plano,
  }) async {
    try {
      final parentDocumentRef = _alunoCollection.doc(alunoId);

      final planoDocRef = await parentDocumentRef
          .collection('plano_treinos')
          .add(plano.toMap());

      for (var treino in plano.treinos) {
        final treinoDocRef =
            await planoDocRef.collection('treinos').add(treino.toMap());
        treino.id = treinoDocRef.id;

        for (var exercicio in treino.exercicios) {
          final exercicioRef = await treinoDocRef
              .collection('exercicios')
              .add(exercicio.toMap());
          exercicio.id = exercicioRef.id;
        }
      }
    } catch (e) {
      throw Exception('Erro ao criar o plano: $e');
    }
  }

  

  Future<PlanoTreino> readAtivoByAluno(Aluno aluno) async {
    try {
      CollectionReference planosTreinoRef =
          _alunoCollection.doc(aluno.id!).collection('plano_treinos');

      // Obter os documentos da subcoleção 'plano_treinos' com status 'ativo'
      DocumentSnapshot snapshot = (await planosTreinoRef
              .where('status', isEqualTo: 'Ativo')
              .limit(1)
              .get())
          .docs
          .first;

      Map<String, dynamic> planoTreinoAtivo =
          snapshot.data()! as Map<String, dynamic>;

      CollectionReference treinosRef = snapshot.reference.collection('treinos');

      QuerySnapshot treinosSnapshot = await treinosRef.get();

      List<Treino> treinos = [];
      for (final doc in treinosSnapshot.docs) {
        CollectionReference exerciciosRef =
            doc.reference.collection('exercicios');
        QuerySnapshot exerciciosSnapshot = await exerciciosRef.get();

        List<Exercicio> exercicios = [];
        for (final doc in exerciciosSnapshot.docs) {
          final exercicioData = doc.data()! as Map<String, dynamic>;
          List<GrupoMuscular> gruposMusculares = [];

          for (final grupoMuscularId in exercicioData['gruposMusculares']) {
            GrupoMuscular grupoMuscular =
                await GrupoMuscularRepository(firestore: _firestore)
                    .readById(grupoMuscularId);
            gruposMusculares.add(grupoMuscular);
          }

          exercicios.add(Exercicio.fromMap(
            exercicioData,
            doc.id,
            gruposMusculares,
          ));
        }

        treinos.add(Treino.fromMap(
            doc.data()! as Map<String, dynamic>, doc.id, exercicios));
      }

      return PlanoTreino.fromMap(planoTreinoAtivo, snapshot.id, treinos);
    } catch (e) {
      throw Exception('Erro ao buscar plano de treino: $e');
    }
  }

  Future<List<PlanoTreino>> readAllByAluno(Aluno aluno) async {
    final planos = <PlanoTreino>[];
    try {
      CollectionReference planosTreinoRef =
          _alunoCollection.doc(aluno.id!).collection('plano_treinos');

      // Obter os documentos da subcoleção 'plano_treinos' com status 'ativo'
      final snapshots = (await planosTreinoRef.get()).docs;

      for (final snapshot in snapshots) {
        Map<String, dynamic> planoTreinoAtivo =
            snapshot.data()! as Map<String, dynamic>;

        CollectionReference treinosRef =
            snapshot.reference.collection('treinos');

        QuerySnapshot treinosSnapshot = await treinosRef.get();

        List<Treino> treinos = [];
        for (final doc in treinosSnapshot.docs) {
          CollectionReference exerciciosRef =
              doc.reference.collection('exercicios');
          QuerySnapshot exerciciosSnapshot = await exerciciosRef.get();

          List<Exercicio> exercicios = [];
          for (final doc in exerciciosSnapshot.docs) {
            final exercicioData = doc.data()! as Map<String, dynamic>;
            List<GrupoMuscular> gruposMusculares = [];

            for (final grupoMuscularId in exercicioData['gruposMusculares']) {
              GrupoMuscular grupoMuscular =
                  await GrupoMuscularRepository(firestore: _firestore)
                      .readById(grupoMuscularId);
              gruposMusculares.add(grupoMuscular);
            }

            exercicios.add(Exercicio.fromMap(
              exercicioData,
              doc.id,
              gruposMusculares,
            ));
          }

          treinos.add(Treino.fromMap(
              doc.data()! as Map<String, dynamic>, doc.id, exercicios));
        }
        
        planos.add(PlanoTreino.fromMap(planoTreinoAtivo, snapshot.id, treinos));
      }

      return planos;
    } catch (e) {
      throw Exception('Erro ao buscar plano de treino: $e');
    }
  }
}
