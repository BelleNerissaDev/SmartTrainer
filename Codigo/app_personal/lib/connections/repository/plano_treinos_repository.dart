import 'package:SmartTrainer_Personal/connections/provider/firestore.dart';
import 'package:SmartTrainer_Personal/connections/repository/grupo_muscular_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';
import 'package:SmartTrainer_Personal/models/entity/plano.dart';
import 'package:SmartTrainer_Personal/models/entity/treino.dart';
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

  Future<void> editPlanoTreinos({
    required String alunoId,
    required String planoId,
    required PlanoTreino plano,
  }) async {
    try {
      final parentDocumentRef = _alunoCollection.doc(alunoId);
      final planoDocRef =
          parentDocumentRef.collection('plano_treinos').doc(planoId);

      // Atualiza os dados do plano
      await planoDocRef.update(plano.toMap());

      final treinosSnapshot = await planoDocRef.collection('treinos').get();
      final treinoMap = {for (var doc in treinosSnapshot.docs) doc.id: doc};

      for (var treino in plano.treinos) {
        if (treino.id != null && treinoMap.containsKey(treino.id)) {
          // Atualiza o treino se ele já existir
          final treinoDocRef = planoDocRef.collection('treinos').doc(treino.id);
          await treinoDocRef.update(treino.toMap());

          // Processa exercícios do treino
          final exerciciosSnapshot =
              await treinoDocRef.collection('exercicios').get();
          final exercicioMap = {
            for (var doc in exerciciosSnapshot.docs) doc.id: doc
          };

          for (var exercicio in treino.exercicios) {
            if (exercicio.id != null &&
                exercicioMap.containsKey(exercicio.id)) {
              // Atualiza o exercício existente
              final exercicioDocRef =
                  treinoDocRef.collection('exercicios').doc(exercicio.id);
              await exercicioDocRef.update(exercicio.toMap());
            } else {
              // Adiciona novo exercício
              await treinoDocRef
                  .collection('exercicios')
                  .add(exercicio.toMap());
            }
          }

          // Remove exercícios não mais presentes na lista de exercícios do plano //
          for (var docId in exercicioMap.keys) {
            if (!treino.exercicios.any((e) => e.id == docId)) {
              await exercicioMap[docId]!.reference.delete();
            }
          }
        } else {
          // Adiciona novo treino
          final treinoDocRef =
              await planoDocRef.collection('treinos').add(treino.toMap());

          for (var exercicio in treino.exercicios) {
            await treinoDocRef.collection('exercicios').add(exercicio.toMap());
          }
        }
      }

      // Remove treinos não mais presentes na lista de treinos do plano
      for (var docId in treinoMap.keys) {
        if (!plano.treinos.any((t) => t.id == docId)) {
          await treinoMap[docId]!.reference.delete();
        }
      }
    } catch (e) {
      throw Exception('Erro ao editar o plano: $e');
    }
  }

  Future<void> deletePlanoTreino({
    required String alunoId,
    required String planoId,
  }) async {
    try {
      final parentDocumentRef = _alunoCollection.doc(alunoId);

      final planoDocRef =
          parentDocumentRef.collection('plano_treinos').doc(planoId);

      final treinosSnapshot = await planoDocRef.collection('treinos').get();

      for (var treinoDoc in treinosSnapshot.docs) {
        final treinoDocRef = treinoDoc.reference;

        final exerciciosSnapshot =
            await treinoDocRef.collection('exercicios').get();

        for (var exercicioDoc in exerciciosSnapshot.docs) {
          await exercicioDoc.reference.delete();
        }

        await treinoDocRef.delete();
      }

      await planoDocRef.delete();
    } catch (e) {
      throw Exception('Erro ao deletar o plano: $e');
    }
  }

// ve se troca id tbm
  Future<void> activatePlanoTreino({
    required String alunoId,
    required String planoId,
  }) async {
    try {
      final parentDocumentRef = _alunoCollection.doc(alunoId);

      final planoTreinosCollection =
          parentDocumentRef.collection('plano_treinos');

      final querySnapshot = await planoTreinosCollection
          .where('status', isEqualTo: 'Ativo')
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'status': 'Inativo'});
      }

      final planoDocRef = planoTreinosCollection.doc(planoId);
      await planoDocRef.update({'status': 'Ativo'});
    } catch (e) {
      throw Exception('Erro ao ativar o plano: $e');
    }
  }

  Future<List<PlanoTreino>> getAllPlanosTreinoFromAluno(String alunoId) async {
    try {
      CollectionReference planosTreinoRef =
          _alunoCollection.doc(alunoId).collection('plano_treinos');

      QuerySnapshot snapshot = await planosTreinoRef.get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      List<PlanoTreino> planosTreino = [];

      final grupoMuscularRepository =
          GrupoMuscularRepository(firestore: _firestore);
      final gruposMusculares = await grupoMuscularRepository.readAll();

      for (var planoDoc in snapshot.docs) {
        Map<String, dynamic> planoTreinoData =
            planoDoc.data()! as Map<String, dynamic>;

        String planoId = planoDoc.id;

        CollectionReference treinosRef =
            planosTreinoRef.doc(planoId).collection('treinos');
        QuerySnapshot treinosSnapshot = await treinosRef.get();

        List<Treino> treinos = [];

        if (treinosSnapshot.docs.isNotEmpty) {
          for (var treinoDoc in treinosSnapshot.docs) {
            Map<String, dynamic> treinoData =
                treinoDoc.data()! as Map<String, dynamic>;

            CollectionReference exerciciosRef =
                treinosRef.doc(treinoDoc.id).collection('exercicios');
            QuerySnapshot exerciciosSnapshot = await exerciciosRef.get();

            List<Exercicio> exercicios = exerciciosSnapshot.docs.map((doc) {
              Map<String, dynamic> exercicioData =
                  doc.data()! as Map<String, dynamic>;

              final filteredGruposMusculares = gruposMusculares
                  .where((grupo) =>
                      exercicioData['gruposMusculares'].contains(grupo.id))
                  .toList();

              exercicioData['gruposMusculares'] = filteredGruposMusculares;

              return Exercicio.fromMap(
                exercicioData,
                exercicioData['id'],
              );
            }).toList();

            Treino treino = Treino.fromMap(
              treinoData,
              treinoDoc.id,
              exercicios,
            );
            treinos.add(treino);
          }
          // Ordena os treinos em ordem alfabética
          treinos.sort((a, b) => a.nome.compareTo(b.nome));
        }
        PlanoTreino planoTreino = PlanoTreino.fromMap(
          planoTreinoData,
          planoId,
          treinos,
        );

        planosTreino.add(planoTreino);
      }

      return planosTreino;
    } catch (e) {
      throw Exception('Erro ao buscar os planos de treino: $e');
    }
  }

  Future<List<PlanoTreino>> getPlanoTreinoFromAluno(String alunoId) async {
    try {
      CollectionReference planosTreinoRef =
          _alunoCollection.doc(alunoId).collection('plano_treinos');

      QuerySnapshot snapshot = await planosTreinoRef
          .where('status', isEqualTo: 'Ativo')
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      Map<String, dynamic> planoTreinoData =
          snapshot.docs.first.data()! as Map<String, dynamic>;

      CollectionReference treinosRef =
          planosTreinoRef.doc(snapshot.docs.first.id).collection('treinos');
      QuerySnapshot treinosSnapshot = await treinosRef.get();

      List<Treino> treinos = [];

      final grupoMuscularRepository =
          GrupoMuscularRepository(firestore: _firestore);
      final gruposMusculares = await grupoMuscularRepository.readAll();

      for (var treinoDoc in treinosSnapshot.docs) {
        Map<String, dynamic> treinoData =
            treinoDoc.data()! as Map<String, dynamic>;

        CollectionReference exerciciosRef =
            treinosRef.doc(treinoDoc.id).collection('exercicios');
        QuerySnapshot exerciciosSnapshot = await exerciciosRef.get();

        List<Exercicio> exercicios = exerciciosSnapshot.docs.map((doc) {
          Map<String, dynamic> exercicioData =
              doc.data()! as Map<String, dynamic>;

          final filteredGruposMusculares = gruposMusculares
              .where((grupo) =>
                  exercicioData['gruposMusculares'].contains(grupo.id))
              .toList();

          exercicioData['gruposMusculares'] = filteredGruposMusculares;

          // Criar o objeto Exercicio a partir dos dados atualizados
          // com o id do exercicio original
          return Exercicio.fromMap(
            exercicioData,
            exercicioData['id'],
          );
        }).toList();

        Treino treino = Treino.fromMap(
          treinoData,
          treinoDoc.id,
          exercicios,
        );

        treinos.add(treino);
      }

      PlanoTreino planoTreino = PlanoTreino.fromMap(
        planoTreinoData,
        snapshot.docs.first.id,
        treinos,
      );

      // Ordena os treinos em ordem alfabética
      planoTreino.treinos.sort((a, b) => a.nome.compareTo(b.nome));

      return [planoTreino];
    } catch (e) {
      throw Exception('Erro ao buscar o plano de treino: $e');
    }
  }

  // Função para obter os planos de treino de um aluno com base no ID
  Future<List<Map<String, dynamic>>> readById(String alunoId) async {
    try {
      CollectionReference planosTreinoRef =
          _alunoCollection.doc(alunoId).collection('plano_treinos');

      // Obter os documentos da subcoleção 'plano_treinos' com status 'ativo'
      QuerySnapshot snapshot = await planosTreinoRef
          .where('status', isEqualTo: 'ativo')
          .limit(1)
          .get();

      // Verificar se existe um plano de treino com status 'ativo'
      if (snapshot.docs.isEmpty) {
        return []; // Retorna null se não houver plano ativo
      }
      Map<String, dynamic> planoTreinoAtivo =
          snapshot.docs.first.data()! as Map<String, dynamic>;

      return [planoTreinoAtivo];
    } catch (e) {
      return [];
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

          exercicioData['gruposMusculares'] = gruposMusculares;

          exercicios.add(Exercicio.fromMap(
            exercicioData,
            doc.id,
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

            exercicioData['gruposMusculares'] = gruposMusculares;

            exercicios.add(Exercicio.fromMap(
              exercicioData,
              doc.id,
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

  Future<int> countAllAtivos() async {
    try {
      final snapshots = await _alunoCollection.get();
      int count = 0;
      for (final snapshot in snapshots.docs) {
        final plano = await snapshot.reference
            .collection('plano_treinos')
            .where('status', isEqualTo: 'Ativo')
            .limit(1)
            .get();
        if (plano.docs.isNotEmpty) {
          count++;
        }
      }
      return count;
    } catch (e) {
      throw Exception('Erro ao buscar plano de treino: $e');
    }
  }
}
