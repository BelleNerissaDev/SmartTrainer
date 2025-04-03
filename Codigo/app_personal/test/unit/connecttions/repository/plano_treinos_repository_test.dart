import 'package:SmartTrainer_Personal/connections/repository/plano_treinos_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:SmartTrainer_Personal/models/entity/plano.dart';
import 'package:SmartTrainer_Personal/models/entity/treino.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('PlanoTreinoRepository', () {
    late FakeFirebaseFirestore instance;
    late PlanoTreinoRepository planoTreinoRepository;

    setUp(() async {
      instance = FakeFirebaseFirestore();
      planoTreinoRepository = PlanoTreinoRepository(firestore: instance);
    });

    test('editPlanoTreinos should update a plano', () async {
      final alunoId = 'aluno1';
      final plano = PlanoTreino(
        nome: 'Plano Treino 1',
        status: 'Ativo',
        treinos: [
          Treino(
            nome: 'Treino A',
            exercicios: [
              Exercicio(
                nome: 'Supino',
                descricao: '',
                carga: 2.0,
                intervalo: '0:35',
                repeticoes: 10,
                series: 3,
                gruposMusculares: [GrupoMuscular(nome: 'Bíceps', id: '2')],
                metodologia: MetodologiaExercicio.TRADICIONAL,
              ),
            ],
          ),
        ],
      );

      await planoTreinoRepository.createPlanoTreinos(
          alunoId: alunoId, plano: plano);

      final snapshot = await instance
          .collection('alunos')
          .doc(alunoId)
          .collection('plano_treinos')
          .get();
      final createdPlanoId = snapshot.docs.first.id;

      final planoAtualizado = PlanoTreino(
        nome: 'Plano B',
        status: 'Ativo',
        treinos: [
          Treino(
            nome: 'Treino 2',
            exercicios: [
              Exercicio(
                nome: 'Supino Inclinado',
                descricao: '',
                carga: 3.0,
                intervalo: '0:45',
                repeticoes: 12,
                series: 4,
                gruposMusculares: [GrupoMuscular(nome: 'Peitoral', id: '3')],
                metodologia: MetodologiaExercicio.TRADICIONAL,
              ),
            ],
          ),
        ],
      );

      await planoTreinoRepository.editPlanoTreinos(
          alunoId: alunoId, planoId: createdPlanoId, plano: planoAtualizado);

      final updatedSnapshot = await instance
          .collection('alunos')
          .doc(alunoId)
          .collection('plano_treinos')
          .doc(createdPlanoId)
          .get();

      final updatedPlanoData = updatedSnapshot.data()!;
      expect(updatedPlanoData['nome'], equals('Plano B'));

      final treinosSnapshot =
          await updatedSnapshot.reference.collection('treinos').get();
      expect(treinosSnapshot.docs.length, equals(1));
      expect(treinosSnapshot.docs.first['nome'], equals('Treino 2'));

      final exerciciosSnapshot = await treinosSnapshot.docs.first.reference
          .collection('exercicios')
          .get();
      expect(exerciciosSnapshot.docs.length, equals(1));
      expect(exerciciosSnapshot.docs.first['nome'], equals('Supino Inclinado'));
    });

    test('activatePlanoTreino should deactivate a plano', () async {
      final alunoId = 'aluno1';
      final plano = PlanoTreino(
        nome: 'Plano A',
        status: 'Inativo',
        treinos: [
          Treino(
            nome: 'Treino 1',
            exercicios: [
              Exercicio(
                nome: 'Supino',
                descricao: '',
                carga: 2.0,
                intervalo: '0:35',
                repeticoes: 10,
                series: 3,
                gruposMusculares: [GrupoMuscular(nome: 'Bíceps', id: '2')],
                metodologia: MetodologiaExercicio.TRADICIONAL,
              ),
            ],
          ),
        ],
      );

      await planoTreinoRepository.createPlanoTreinos(
          alunoId: alunoId, plano: plano);

      final snapshot = await instance
          .collection('alunos')
          .doc(alunoId)
          .collection('plano_treinos')
          .get();
      final createdPlanoId = snapshot.docs.first.id;

      await planoTreinoRepository.activatePlanoTreino(
        alunoId: alunoId,
        planoId: createdPlanoId,
      );

      final updatedSnapshot = await instance
          .collection('alunos')
          .doc(alunoId)
          .collection('plano_treinos')
          .doc(createdPlanoId)
          .get();

      final updatedPlanoData = updatedSnapshot.data()!;
      expect(updatedPlanoData['status'], equals('Ativo'));
    });
    test('deletePlanoTreino should delete a plano', () async {
      final alunoId = 'aluno1';
      final plano = PlanoTreino(
        nome: 'Plano Treino 1',
        status: 'Ativo',
        treinos: [
          Treino(
            nome: 'Treino A',
            exercicios: [
              Exercicio(
                nome: 'Supino',
                descricao: '',
                carga: 2.0,
                intervalo: '0:35',
                repeticoes: 10,
                series: 3,
                gruposMusculares: [GrupoMuscular(nome: 'Bíceps', id: '2')],
                metodologia: MetodologiaExercicio.TRADICIONAL,
              ),
            ],
          ),
        ],
      );

      await planoTreinoRepository.createPlanoTreinos(
          alunoId: alunoId, plano: plano);

      final snapshot = await instance
          .collection('alunos')
          .doc(alunoId)
          .collection('plano_treinos')
          .get();
      final createdPlanoId = snapshot.docs.first.id;

      await planoTreinoRepository.deletePlanoTreino(
          alunoId: alunoId, planoId: createdPlanoId);

      final deletedSnapshot = await instance
          .collection('alunos')
          .doc(alunoId)
          .collection('plano_treinos')
          .doc(createdPlanoId)
          .get();

      expect(deletedSnapshot.exists, isFalse);
    });

    test('getAllPlanosTreinoFromAluno should return all planos', () async {
      final alunoId = 'aluno1';
      final plano1 = PlanoTreino(
        nome: 'Plano Treino 1',
        status: 'Ativo',
        treinos: [
          Treino(
            nome: 'Treino A',
            exercicios: [
              Exercicio(
                id: 'exercicio1',
                nome: 'Supino',
                descricao: '',
                carga: 2.0,
                intervalo: '0:35',
                repeticoes: 10,
                series: 3,
                gruposMusculares: [GrupoMuscular(nome: 'Bíceps', id: '2')],
                metodologia: MetodologiaExercicio.TRADICIONAL,
              ),
            ],
          ),
        ],
      );

      final plano2 = PlanoTreino(
        nome: 'Plano Treino 2',
        status: 'Inativo',
        treinos: [
          Treino(
            nome: 'Treino B',
            exercicios: [
              Exercicio(
                id: 'exercicio2',
                nome: 'Agachamento',
                descricao: '',
                carga: 5.0,
                intervalo: '0:45',
                repeticoes: 12,
                series: 4,
                gruposMusculares: [GrupoMuscular(nome: 'Quadríceps', id: '3')],
                metodologia: MetodologiaExercicio.TRADICIONAL,
              ),
            ],
          ),
        ],
      );

      await planoTreinoRepository.createPlanoTreinos(
          alunoId: alunoId, plano: plano1);
      await planoTreinoRepository.createPlanoTreinos(
          alunoId: alunoId, plano: plano2);

      final planos =
          await planoTreinoRepository.getAllPlanosTreinoFromAluno(alunoId);

      expect(planos.length, equals(2));
      expect(planos[0].nome, equals('Plano Treino 1'));
      expect(planos[1].nome, equals('Plano Treino 2'));
    });

    test('getPlanoTreinoFromAluno should return active plano', () async {
      final alunoId = 'aluno1';
      final plano = PlanoTreino(
        nome: 'Plano Treino 1',
        status: 'Ativo',
        treinos: [
          Treino(
            nome: 'Treino A',
            exercicios: [
              Exercicio(
                id: 'exercicio1',
                nome: 'Supino',
                descricao: '',
                carga: 2.0,
                intervalo: '0:35',
                repeticoes: 10,
                series: 3,
                gruposMusculares: [GrupoMuscular(nome: 'Bíceps', id: '2')],
                metodologia: MetodologiaExercicio.TRADICIONAL,
              ),
            ],
          ),
        ],
      );

      await planoTreinoRepository.createPlanoTreinos(
          alunoId: alunoId, plano: plano);

      final planos =
          await planoTreinoRepository.getPlanoTreinoFromAluno(alunoId);

      expect(planos.length, equals(1));
      expect(planos[0].nome, equals('Plano Treino 1'));
      expect(planos[0].status, equals('Ativo'));
    });

    test('countAllAtivos should return the count of active planos', () async {
      final pacote = Pacote(
        nome: 'nome',
        valorMensal: '100',
        numeroAcessos: '20',
        id: 'pacoteId',
      );

      final aluno1 = Aluno(
        nome: 'aluno1',
        telefone: '31 9999999',
        email: 'email@example.com',
        sexo: 'Masculino',
        status: StatusAlunoEnum.ATIVO,
        uid: 'uniqueUUID',
        primeiroAcesso: false,
        dataNascimento: DateTime(2020),
        pacote: pacote,
      );
      final aluno2 = Aluno(
        nome: 'aluno2',
        telefone: '31 9999999',
        email: 'email@example.com',
        sexo: 'Masculino',
        status: StatusAlunoEnum.ATIVO,
        uid: 'uniqueUUID',
        primeiroAcesso: false,
        dataNascimento: DateTime(2020),
        pacote: pacote,
      );

      final referenceAluno1 =
          await instance.collection('alunos').add(aluno1.toMap());
      final referenceAluno2 =
          await instance.collection('alunos').add(aluno2.toMap());

      final alunoId1 = referenceAluno1.id;
      final alunoId2 = referenceAluno2.id;

      final plano1 = PlanoTreino(
        nome: 'Plano Treino 1',
        status: 'Ativo',
        treinos: [
          Treino(
            nome: 'Treino A',
            exercicios: [
              Exercicio(
                nome: 'Supino',
                descricao: '',
                carga: 2.0,
                intervalo: '0:35',
                repeticoes: 10,
                series: 3,
                gruposMusculares: [GrupoMuscular(nome: 'Bíceps', id: '2')],
                metodologia: MetodologiaExercicio.TRADICIONAL,
              ),
            ],
          ),
        ],
      );

      final plano2 = PlanoTreino(
        nome: 'Plano Treino 2',
        status: 'Ativo',
        treinos: [
          Treino(
            nome: 'Treino B',
            exercicios: [
              Exercicio(
                nome: 'Agachamento',
                descricao: '',
                carga: 5.0,
                intervalo: '0:45',
                repeticoes: 12,
                series: 4,
                gruposMusculares: [GrupoMuscular(nome: 'Quadríceps', id: '3')],
                metodologia: MetodologiaExercicio.TRADICIONAL,
              ),
            ],
          ),
        ],
      );

      await planoTreinoRepository.createPlanoTreinos(
          alunoId: alunoId1, plano: plano1);
      await planoTreinoRepository.createPlanoTreinos(
          alunoId: alunoId2, plano: plano2);

      final count = await planoTreinoRepository.countAllAtivos();

      expect(count, equals(2));
    });
  });
}
