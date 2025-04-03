import 'package:SmartTrainer/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/pacote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AlunoRepository', () {
    late FakeFirebaseFirestore instance;
    late AlunoRepository alunoRepository;
    late Pacote pacote;

    setUp(() async {
      instance = FakeFirebaseFirestore();
      alunoRepository = AlunoRepository(firestore: instance);

      pacote = Pacote(
        nome: 'pacote 1',
        valorMensal: '200',
        numeroAcessos: '30',
      );

      final document = await instance.collection('pacotes').add(pacote.toMap());
      pacote.id = document.id;
    });

    test('readById', () async {
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
        'dataNascimento': Timestamp.fromDate(DateTime(1990, 1, 1)),
        'pacoteId': pacote.id,
      };
      final document = await instance.collection('alunos').add(data);

      final id = document.id;

      Aluno aluno = await alunoRepository.readById(id);
      expect(aluno.id!, id);
      expect(aluno.nome, equals('John Doe'));
      expect(aluno.telefone, equals('123456789'));
    });

    test('update', () async {
      final data = {
        'nome': 'John Doe',
        'telefone': '123456789',
        'email': 'john.doe@example.com',
        'sexo': 'Male',
        'imagem': null,
        'status': 'Ativo',
        'peso': 70.5,
        'altura': 180,
        'uid': 'uniqueId',
        'primeiroAcesso': true,
        'dataNascimento': Timestamp.fromDate(DateTime(1990, 1, 1)),
        'pacoteId': pacote.id,
      };
      final document = await instance.collection('alunos').add(data);

      final id = document.id;

      Aluno? aluno = Aluno.fromMap(
          data,
          id,
          Pacote(
            nome: 'pacote 1',
            valorMensal: '200',
            numeroAcessos: '30',
          ));

      aluno!.primeiroAcesso = false;
      aluno.nome = 'Mario';

      aluno = await alunoRepository.update(aluno);
      expect(aluno.nome, equals('Mario'));
      expect(aluno.primeiroAcesso, isFalse);
    });

    test('readBy return Aluno', () async {
      final key = 'uid';
      final value = 'uid';

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
        'dataNascimento': Timestamp.fromDate(DateTime(1990, 1, 1)),
        'pacoteId': pacote.id,
      };
      await instance.collection('alunos').add(data);

      Aluno aluno = await alunoRepository.readBy(key, value);
      expect(aluno.nome, equals('John Doe'));
      expect(aluno.telefone, equals('123456789'));
    });

    test('readBy throw Exception', () async {
      final key = 'uid';
      final value = 'gggg';

      expect(() async => alunoRepository.readBy(key, value), throwsException);
    });
  });
}
