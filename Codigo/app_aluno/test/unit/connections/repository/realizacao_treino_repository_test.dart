import 'package:SmartTrainer/connections/repository/plano_treinos_repository.dart';
import 'package:SmartTrainer/connections/repository/realizacao_treino_repository.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/exercicio.dart';
import 'package:SmartTrainer/models/entity/feedback.dart';
import 'package:SmartTrainer/models/entity/nivel_esforco.dart';
import 'package:SmartTrainer/models/entity/pacote.dart';
import 'package:SmartTrainer/models/entity/plano_treino.dart';
import 'package:SmartTrainer/models/entity/realizacao_exercicio.dart';
import 'package:SmartTrainer/models/entity/realizacao_treino.dart';
import 'package:SmartTrainer/models/entity/treino.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('PlanoTreinoRepository', () {
    late FakeFirebaseFirestore instance;
    late RealizacaoTreinoRepository realizacaoTreinoRepository;
    final pacote = Pacote(
      nome: 'pacote1',
      numeroAcessos: '30',
      valorMensal: '100',
      id: 'pacote1',
    );
    late Aluno aluno;

    setUp(() async {
      instance = FakeFirebaseFirestore();
      realizacaoTreinoRepository =
          RealizacaoTreinoRepository(firestore: instance);

      aluno = Aluno(
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
      final reference = await instance.collection('alunos').add(aluno.toMap());
      aluno.id = reference.id;
    });

    test('create RealizacaoTreino', () async {
      final treino = Treino(
        nome: 'nome',
        exercicios: [
          Exercicio(
            nome: 'exercicio',
            metodologia: MetodologiaExercicio.TRADICIONAL,
            descricao: 'descricao',
            carga: 50,
            repeticoes: 2,
            series: 2,
            intervalo: 'intervalo',
          ),
        ],
        id: 'treino1',
      );
      final plano = PlanoTreino(
        nome: 'nome',
        status: 'Ativo',
        treinos: [treino],
      );
      await PlanoTreinoRepository(firestore: instance)
          .createPlanoTreinos(alunoId: aluno.id!, plano: plano);

      final realizacaoTreino = RealizacaoTreino(
          data: DateTime.now(),
          treino: treino,
          tempo: 3600,
          feedback: Feedback(
            nivelEsforco: NivelEsforco.MEDIO,
            observacao: 'observacoes',
          ),
          realizacaoExercicios: [
            RealizacaoExercicio(
              idExercicio: treino.exercicios.first.id!,
              nivelEsforco: NivelEsforco.MUITO_ALTO,
              novaCarga: 60,
            )
          ]);

      final createdRealizacaoTreino =
          await realizacaoTreinoRepository.create(aluno, realizacaoTreino);

      expect(createdRealizacaoTreino.id, isNotNull);
      expect(createdRealizacaoTreino.data, isNotNull);
      expect(createdRealizacaoTreino.treino.id, treino.id);
      expect(createdRealizacaoTreino.tempo, 3600);
      expect(createdRealizacaoTreino.feedback, isNotNull);
      expect(
          createdRealizacaoTreino.feedback!.nivelEsforco, NivelEsforco.MEDIO);
      expect(createdRealizacaoTreino.feedback!.observacao, 'observacoes');
      expect(createdRealizacaoTreino.realizacaoExercicios, isNotEmpty);
      expect(createdRealizacaoTreino.realizacaoExercicios.first.nivelEsforco,
          NivelEsforco.MUITO_ALTO);
      expect(createdRealizacaoTreino.realizacaoExercicios.first.novaCarga, 60);
    });

    test('readAllByAlunoByMes returns list of RealizacaoTreino', () async {
      final treino = Treino(
        nome: 'nome',
        exercicios: [
          Exercicio(
            nome: 'exercicio',
            metodologia: MetodologiaExercicio.TRADICIONAL,
            descricao: 'descricao',
            carga: 50,
            repeticoes: 2,
            series: 2,
            intervalo: 'intervalo',
          ),
        ],
        id: 'treino1',
      );
      final plano = PlanoTreino(
        nome: 'nome',
        status: 'Ativo',
        treinos: [treino],
      );

      await PlanoTreinoRepository(firestore: instance)
          .createPlanoTreinos(alunoId: aluno.id!, plano: plano);

      final realizacoes = [
        RealizacaoTreino(
          data: DateTime(2023, 10, 10),
          treino: treino,
          feedback: Feedback(
            nivelEsforco: NivelEsforco.BAIXO,
            observacao: 'observacao',
          ),
          realizacaoExercicios: [
            RealizacaoExercicio(
              novaCarga: 50,
              nivelEsforco: NivelEsforco.MEDIO,
              idExercicio: treino.exercicios.first.id!,
            ),
          ],
          tempo: 3600,
        ),
        RealizacaoTreino(
          data: DateTime(2023, 10, 11),
          treino: treino,
          feedback: Feedback(
            nivelEsforco: NivelEsforco.BAIXO,
            observacao: 'observacao',
          ),
          realizacaoExercicios: [
            RealizacaoExercicio(
              novaCarga: 50,
              nivelEsforco: NivelEsforco.MEDIO,
              idExercicio: treino.exercicios.first.id!,
            ),
          ],
          tempo: 3500,
        ),
        RealizacaoTreino(
          data: DateTime(2023, 10, 12),
          treino: treino,
          feedback: Feedback(
            nivelEsforco: NivelEsforco.BAIXO,
            observacao: 'observacao',
          ),
          realizacaoExercicios: [
            RealizacaoExercicio(
              novaCarga: 50,
              nivelEsforco: NivelEsforco.MEDIO,
              idExercicio: treino.exercicios.first.id!,
            ),
          ],
          tempo: 3400,
        ),
      ];

      for (final realizacao in realizacoes) {
        await realizacaoTreinoRepository.create(aluno, realizacao);
      }

      final mes = DateTime(2023, 10);

      final realizacoesTreino =
          await realizacaoTreinoRepository.readAllByAlunoByMes(aluno, mes);

      expect(realizacoesTreino, isA<List<RealizacaoTreino>>());
      expect(realizacoesTreino.length, 3);

      expect(realizacoesTreino[0].data, DateTime(2023, 10, 10));
      expect(realizacoesTreino[0].treino.id, treino.id);
      expect(realizacoesTreino[0].tempo, 3600);
      expect(realizacoesTreino[0].feedback!.nivelEsforco, NivelEsforco.BAIXO);
      expect(realizacoesTreino[0].feedback!.observacao, 'observacao');
      expect(realizacoesTreino[0].realizacaoExercicios.first.nivelEsforco,
          NivelEsforco.MEDIO);
      expect(realizacoesTreino[0].realizacaoExercicios.first.novaCarga, 50);

      expect(realizacoesTreino[1].data, DateTime(2023, 10, 11));
      expect(realizacoesTreino[1].treino.id, treino.id);
      expect(realizacoesTreino[1].tempo, 3500);
      expect(realizacoesTreino[1].feedback!.nivelEsforco, NivelEsforco.BAIXO);
      expect(realizacoesTreino[1].feedback!.observacao, 'observacao');
      expect(realizacoesTreino[1].realizacaoExercicios.first.nivelEsforco,
          NivelEsforco.MEDIO);
      expect(realizacoesTreino[1].realizacaoExercicios.first.novaCarga, 50);

      expect(realizacoesTreino[2].data, DateTime(2023, 10, 12));
      expect(realizacoesTreino[2].treino.id, treino.id);
      expect(realizacoesTreino[2].tempo, 3400);
      expect(realizacoesTreino[2].feedback!.nivelEsforco, NivelEsforco.BAIXO);
      expect(realizacoesTreino[2].feedback!.observacao, 'observacao');
      expect(realizacoesTreino[2].realizacaoExercicios.first.nivelEsforco,
          NivelEsforco.MEDIO);
      expect(realizacoesTreino[2].realizacaoExercicios.first.novaCarga, 50);
    });

  });
}
