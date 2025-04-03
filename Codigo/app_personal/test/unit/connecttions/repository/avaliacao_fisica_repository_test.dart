import 'package:SmartTrainer_Personal/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer_Personal/connections/repository/avaliacao_fisica_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/avaliacao_fisica.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  group('AvaliacaoRepository', () {
    late FakeFirebaseFirestore instance;
    late AvaliacaoFisicaRepository avaliacaoRepository;
    late Pacote pacote;

    setUp(() async {
      instance = FakeFirebaseFirestore();
      avaliacaoRepository = AvaliacaoFisicaRepository(
        firestore: instance,
      );
      pacote = Pacote(
        nome: 'pacote 1',
        valorMensal: '200',
        numeroAcessos: '30',
      );

      final document = await instance.collection('pacotes').add(pacote.toMap());
      pacote.id = document.id;
    });

    test('create should add a new AvaliacaoFisica and return it with an id',
        () async {
      final alunoRepository = AlunoRepository(firestore: instance);
      final data = {
        'nome': 'John Doe',
        'telefone': '123456789',
        'email': 'john.doe@example.com',
        'sexo': 'Male',
        'imagem': null,
        'status': 'Ativo',
        'peso': 70.5,
        'altura': 180,
        'uid': 'uid',
        'primeiroAcesso': true,
        'dataNascimento': Timestamp.now(),
        'pacoteId': pacote.id,
      };
      final document = await instance.collection('alunos').add(data);
      final alunoId = document.id;
      Aluno aluno = await alunoRepository.readById(alunoId);

      final avaliacao = AvaliacaoFisica(
        data: DateTime.now(),
        aluno: aluno,
        status: StatusAvaliacao.pendente,
        tipoAvaliacao: TipoAvaliacao.pdf,
      );

      await avaliacaoRepository.create(avaliacao);
      expect(avaliacao.id, isNotNull);

      final snapshot = await instance
          .collection('alunos')
          .doc(alunoId)
          .collection('avaliacoes')
          .doc(avaliacao.id)
          .get();

      final createdAvaliacaoData = snapshot.data();
      final createdAvaliacao = AvaliacaoFisica.fromMap(createdAvaliacaoData!);

      expect(avaliacao.data, equals(createdAvaliacao!.data));
      expect(avaliacao.status, equals(createdAvaliacao.status));
      expect(avaliacao.tipoAvaliacao, equals(createdAvaliacao.tipoAvaliacao));
    });

    test('create should throw an exception if aluno is not informed', () async {
      final avaliacao = AvaliacaoFisica(
        data: DateTime.now(),
        status: StatusAvaliacao.pendente,
        tipoAvaliacao: TipoAvaliacao.pdf,
      );

      expect(() => avaliacaoRepository.create(avaliacao),
          throwsA(isA<Exception>()));
    });

    test('ReadByAlunoId should return a list of AvaliacaoFisica', () async {
      final data = {
        'nome': 'John Doe',
        'telefone': '123456789',
        'email': 'john.doe@example.com',
        'sexo': 'Male',
        'imagem': null,
        'status': 'Ativo',
        'peso': 70.5,
        'altura': 180,
        'uid': 'uid',
        'primeiroAcesso': true,
        'dataNascimento': DateTime.now(),
        'pacoteId': pacote.id,
      };
      final document = await instance.collection('alunos').add(data);
      final alunoId = document.id;

      final avaliacoesData = [
        {
          'data': DateTime.now(),
          'status': StatusAvaliacao.pendente.name,
          'tipoAvaliacao': TipoAvaliacao.online.name,
        },
        {
          'data': DateTime.now(),
          'status': StatusAvaliacao.pendente.name,
          'tipoAvaliacao': TipoAvaliacao.pdf.name,
        },
        {
          'data': DateTime.now(),
          'status': StatusAvaliacao.pendente.name,
          'tipoAvaliacao': TipoAvaliacao.online.name,
        },
      ];
      for (final avaliacaoData in avaliacoesData) {
        await instance
            .collection('alunos')
            .doc(alunoId)
            .collection('avaliacoes')
            .add(avaliacaoData);
      }
      final avaliacoes = await avaliacaoRepository.readByAlunoId(alunoId);

      expect(avaliacoes.length, equals(avaliacoesData.length));
    });

    test('update should update an existing AvaliacaoFisica', () async {
      final alunoRepository = AlunoRepository(firestore: instance);
      final data = {
        'nome': 'John Doe',
        'telefone': '123456789',
        'email': 'john.doe@example.com',
        'sexo': 'Male',
        'imagem': null,
        'status': 'Ativo',
        'peso': 70.5,
        'altura': 180,
        'uid': 'uid',
        'primeiroAcesso': true,
        'dataNascimento': Timestamp.now(),
        'pacoteId': pacote.id,
      };
      final document = await instance.collection('alunos').add(data);
      final alunoId = document.id;
      Aluno aluno = await alunoRepository.readById(alunoId);

      final avaliacao = AvaliacaoFisica(
        data: DateTime.now(),
        aluno: aluno,
        status: StatusAvaliacao.pendente,
        tipoAvaliacao: TipoAvaliacao.pdf,
      );

      await avaliacaoRepository.create(avaliacao);
      expect(avaliacao.id, isNotNull);

      avaliacao.status = StatusAvaliacao.realizada;
      await avaliacaoRepository.update(avaliacao);

      final snapshot = await instance
          .collection('alunos')
          .doc(alunoId)
          .collection('avaliacoes')
          .doc(avaliacao.id)
          .get();

      final updatedAvaliacaoData = snapshot.data();
      final updatedAvaliacao = AvaliacaoFisica.fromMap(updatedAvaliacaoData!);

      expect(updatedAvaliacao!.status, equals(StatusAvaliacao.realizada));
    });

    test('update should throw an exception if aluno is not informed', () async {
      final avaliacao = AvaliacaoFisica(
        data: DateTime.now(),
        status: StatusAvaliacao.pendente,
        tipoAvaliacao: TipoAvaliacao.pdf,
      );

      expect(() => avaliacaoRepository.update(avaliacao),
          throwsA(isA<Exception>()));
    });
    test(
        '''countAllPendentes should return the correct count of pending evaluations''',
        () async {
      final data = {
        'nome': 'John Doe',
        'telefone': '123456789',
        'email': 'john.doe@example.com',
        'sexo': 'Male',
        'imagem': null,
        'status': 'Ativo',
        'peso': 70.5,
        'altura': 180,
        'uid': 'uid',
        'primeiroAcesso': true,
        'dataNascimento': DateTime.now(),
        'pacoteId': pacote.id,
      };
      final document = await instance.collection('alunos').add(data);
      final alunoId = document.id;

      final avaliacoesData = [
        {
          'data': DateTime.now(),
          'status': StatusAvaliacao.pendente.name,
          'tipoAvaliacao': TipoAvaliacao.online.name,
        },
        {
          'data': DateTime.now(),
          'status': StatusAvaliacao.realizada.name,
          'tipoAvaliacao': TipoAvaliacao.pdf.name,
        },
        {
          'data': DateTime.now(),
          'status': StatusAvaliacao.pendente.name,
          'tipoAvaliacao': TipoAvaliacao.online.name,
        },
      ];
      for (final avaliacaoData in avaliacoesData) {
        await instance
            .collection('alunos')
            .doc(alunoId)
            .collection('avaliacoes')
            .add(avaliacaoData);
      }

      final count = await avaliacaoRepository.countAllPendentes();
      expect(count, equals(1));
    });
  });
}
