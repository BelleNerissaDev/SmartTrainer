import 'package:SmartTrainer_Personal/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('AlunoRepository', () {
    late FakeFirebaseFirestore instance;
    late AlunoRepository alunoRepository;
    late Aluno aluno;
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
        pacote: pacote,
      );
    });

    test('create should add a new aluno to the collection', () async {
      await alunoRepository.create(aluno);

      expect(aluno.id, isNotNull);

      final snapshot = await instance.collection('alunos').doc(aluno.id).get();
      final createdUserData = snapshot.data();

      final createdAluno = Aluno.fromMap(
        createdUserData!,
        '',
        pacote,
      );

      expect(aluno.nome, equals(createdAluno!.nome));
      expect(aluno.telefone, equals(createdAluno.telefone));
      expect(aluno.email, equals(createdAluno.email));
      expect(aluno.sexo, equals(createdAluno.sexo));
      expect(aluno.imagem, equals(createdAluno.imagem));
      expect(aluno.status, equals(createdAluno.status));
      expect(aluno.peso, equals(createdAluno.peso));
      expect(aluno.altura, equals(createdAluno.altura));
      expect(aluno.uid, equals(createdAluno.uid));
    });

    test('readAll', () async {
      final data = [
        {
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
        },
        {
          'nome': 'Mary Doe',
          'telefone': '123456789',
          'email': 'mary.doe@example.com',
          'sexo': 'Female',
          'imagem': null,
          'status': 'Ativo',
          'peso': 70.5,
          'altura': 180,
          'uid': 'uid1',
          'primeiroAcesso': false,
          'dataNascimento': DateTime.now(),
          'pacoteId': pacote.id,
        },
        {
          'nome': 'Jack Doe',
          'telefone': '123456789',
          'email': 'jack.doe@example.com',
          'sexo': 'Male',
          'imagem': null,
          'status': 'Ativo',
          'peso': 70.5,
          'altura': 180,
          'uid': 'uid2',
          'primeiroAcesso': true,
          'dataNascimento': DateTime.now(),
          'pacoteId': pacote.id,
        },
      ];

      for (final item in data) {
        await instance.collection('alunos').add(item);
      }

      final alunos = await alunoRepository.readAll();

      expect(alunos.length, equals(3));
      expect(alunos[0].nome, equals('John Doe'));
      expect(alunos[1].nome, equals('Mary Doe'));
      expect(alunos[2].nome, equals('Jack Doe'));
    });

    test('readAll return empty when has no data', () async {
      final alunos = await alunoRepository.readAll();

      expect(alunos, isEmpty);
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
        'dataNascimento': DateTime.now(),
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
        'dataNascimento': DateTime.now(),
        'pacoteId': pacote.id,
      };
      final document = await instance.collection('alunos').add(data);

      final id = document.id;

      final snapshot = await instance.collection('alunos').doc(id).get();
      final createdUserData = snapshot.data();

      Aluno? aluno = Aluno.fromMap(
        createdUserData!,
        '',
        pacote,
      );

      aluno!.id = id;
      aluno.primeiroAcesso = false;
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
        'dataNascimento': DateTime.now(),
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
    test('countAll should return the correct number of alunos', () async {
      final data = [
        {
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
        },
        {
          'nome': 'Mary Doe',
          'telefone': '123456789',
          'email': 'mary.doe@example.com',
          'sexo': 'Female',
          'imagem': null,
          'status': 'Ativo',
          'peso': 70.5,
          'altura': 180,
          'uid': 'uid1',
          'primeiroAcesso': false,
          'dataNascimento': DateTime.now(),
          'pacoteId': pacote.id,
        },
      ];

      for (final item in data) {
        await instance.collection('alunos').add(item);
      }

      final count = await alunoRepository.countAll();

      expect(count, equals(2));
    });

    test('readAllWithPlanos should return alunos with plano_treinos', () async {
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

      final alunoDoc = await instance.collection('alunos').add(data);
      await alunoDoc.collection('plano_treinos').add({'plano': 'plano1'});

      final alunos = await alunoRepository.readAllWithPlanos();

      expect(alunos.length, equals(1));
      expect(alunos[0].nome, equals('John Doe'));
    });

    test('readAllWithPlanos should return empty list when no plano_treinos',
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

      await instance.collection('alunos').add(data);

      final alunos = await alunoRepository.readAllWithPlanos();

      expect(alunos, isEmpty);
    });
  });
}
