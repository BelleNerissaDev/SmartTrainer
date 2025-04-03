import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/pacote.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/connections/repository/avaliacao_fisica_repository.dart';
import 'package:SmartTrainer/models/entity/avaliacao_fisica.dart';

void main() {
  late FakeFirebaseFirestore instance;
  late AvaliacaoFisicaRepository repository;
  late Aluno aluno;

  setUp(() async {
    instance = FakeFirebaseFirestore();
    aluno = Aluno(
      nome: 'John Doe',
      telefone: '123456789',
      email: 'john.doe@example.com',
      sexo: 'Male',
      status: StatusAlunoEnum.ATIVO,
      peso: 70.5,
      altura: 180,
      uid: 'uid',
      imagem: null,
      primeiroAcesso: true,
      dataNascimento: DateTime(1990, 1, 1),
      pacote: Pacote(
        nome: 'pacote 1',
        valorMensal: '200',
        numeroAcessos: '30',
      ),
    );
    final doc = await instance.collection('alunos').add(aluno.toMap());
    aluno.id = doc.id;

    repository = AvaliacaoFisicaRepository(firestore: instance);
  });

  group('AvaliacaoFisicaRepository', () {
    test('create should add a new AvaliacaoFisica and return it with an id',
        () async {
      final avaliacao = AvaliacaoFisica(
          data: DateTime.now(),
          status: StatusAvaliacao.pendente,
          tipoAvaliacao: TipoAvaliacao.online,
          aluno: aluno);

      await repository.create(avaliacao);

      expect(avaliacao.id, isNotNull);
      final snapshot = await instance
          .collection('alunos')
          .doc(aluno.id)
          .collection('avaliacoes')
          .doc(avaliacao.id)
          .get();
      expect(snapshot.exists, true);
    });

    test('update should update an existing AvaliacaoFisica', () async {
      final avaliacao = AvaliacaoFisica(
          data: DateTime.now(),
          status: StatusAvaliacao.pendente,
          tipoAvaliacao: TipoAvaliacao.online,
          aluno: aluno);
      final doc = await instance
          .collection('alunos')
          .doc(aluno.id)
          .collection('avaliacoes')
          .add(avaliacao.toMap());
      avaliacao.id = doc.id;
      avaliacao.status = StatusAvaliacao.realizada;

      await repository.update(avaliacao);

      final snapshot = await instance
          .collection('alunos')
          .doc(aluno.id)
          .collection('avaliacoes')
          .doc(avaliacao.id)
          .get();
      expect(snapshot.exists, true);
      expect(snapshot.data()!['status'], 'Realizada');
    });

    test('readByAlunoId should return a list of AvaliacaoFisica', () async {
      final avaliacoes = [
        AvaliacaoFisica(
            data: DateTime.now(),
            status: StatusAvaliacao.pendente,
            tipoAvaliacao: TipoAvaliacao.online,
            aluno: aluno),
        AvaliacaoFisica(
            data: DateTime.now(),
            status: StatusAvaliacao.pendente,
            tipoAvaliacao: TipoAvaliacao.online,
            aluno: aluno),
        AvaliacaoFisica(
            data: DateTime.now(),
            status: StatusAvaliacao.pendente,
            tipoAvaliacao: TipoAvaliacao.online,
            aluno: aluno),
      ];

      for (final avaliacao in avaliacoes) {
        await repository.create(avaliacao);
      }

      final result = await repository.readByAlunoId(aluno.id!);

      expect(result.length, avaliacoes.length);
      for (final avaliacao in result) {
        expect(avaliacao.id, isNotNull);
      }
    });
  });
}
